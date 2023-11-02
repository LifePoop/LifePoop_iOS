//
//  DefaultLoginUseCase.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity
import FeatureLoginDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultLoginUseCase: LoginUseCase {

    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase

    @Inject(LoginDIContainer.shared) private var loginRepository: LoginRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository

    public init() { }
    
    /** 로컬 기기에 저장된 사용자 정보로 자동 로그인 처리 요청 */
    public func requestAutoLoginWithExistingUserInfo() -> Observable<Bool> {
        userInfoUseCase.userInfo
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                
                Logger.log(
                    message: "기기에 기존 인증정보 존재 확인 : \(userInfo != nil)",
                    category: .authentication,
                    type: .debug
                )
                
                if let authInfo = userInfo?.authInfo {
                    return self.userInfoUseCase.refreshAuthInfo(with: authInfo)
                } else {
                    return Observable.just(false)
                }
            }
    }

    /** OAuth 토큰 정보로 Lifepoo Access Token, Refresh Token 획득 및 로그인 처리 요청 */
    public func requestLogin(with oAuthTokenInfo: OAuthTokenInfo) -> Observable<Result<Bool, LoginError>> {
        loginRepository
            .requestAuthInfoWithOAuthAccessToken(with: oAuthTokenInfo)
            .do(onSuccess: { [weak self] loginResult in
                self?.printConsoleLog(with: loginResult)
            })
            .asObservable()
            .withLatestFrom(userInfoUseCase.userInfo) {
                (updatedAuthInfo: $0, loginResult: $1)
            }
            .flatMapLatest { [weak self] loginResult, originalUserInfo -> Observable<Result<Bool, LoginError>> in
                guard let `self` = self else { return .just(.failure(.userNotExists)) }
                
                switch loginResult {
                case .success(let updatedAuthInfo):
                    guard let updatedAuthInfo = updatedAuthInfo else {
                        return .just(.failure(.updatedAuthInfoNil))
                    }

                    let userInfoExists = originalUserInfo != nil
                    Logger.log(
                        message: "KeyChain 내 회원정보 존재 확인: \(userInfoExists)",
                        category: .authentication,
                        type: .debug
                    )

                    if userInfoExists {
                        return .just(.success(true))
                    } else {
                        return self.userInfoUseCase.fetchUserInfo(with: updatedAuthInfo)
                            .map { $0 ? .success($0) : .failure(.failedFetchingUserInfo) }
                    }
                case .failure(let loginError):
                    switch loginError {
                    case .userNotExists:
                        return .just(.success(false))
                    default:
                        return .error(loginError)
                    }
                }
            }
            .catch { error in
                Observable.just(.failure(.otherNetworkError(error: error)))
            }
    }
    
    /** 소셜 로그인(Apple, Kakao) OAuth Access Token 요청*/
    public func fetchOAuthAccessToken(for loginType: LoginType) -> Observable<OAuthTokenInfo?> {
        loginRepository.fetchOAuthAccessToken(for: loginType)
            .catchAndReturn("")
            .logErrorIfDetected(category: .authentication)
            .filter { !$0.isEmpty }
            .asObservable()
            .map { OAuthTokenInfo(loginType: loginType, accessToken: $0) }
            .logErrorIfDetected(category: .authentication)
    }
    
    public func clearUserAuthInfoIfLaunchedFirstly() -> Completable {
        isAppFirstlyLaunched
            .do(onNext: {
                Logger.log(
                    message: "앱 설치 후 최초 기동 여부 확인: \($0)",
                    category: .authentication,
                    type: .debug
                )
            })
            .filter { $0 }
            .withUnretained(self)
            .do(onNext: { _, _ in
                Logger.log(
                    message: "KeyChain에서 사용자 인증 정보를 확인합니다.",
                    category: .authentication,
                    type: .debug
                )
            })
            .concatMap { `self`, _ in
                self.keyChainRepository
                    .getBinaryDataFromKeyChain(
                        forKey: .userAuthInfo,
                        handleExceptionWhenValueNotFound: false
                    )
                    .do(onSuccess: { data in
                        var message: String
                        if let _ = data {
                            message = "KeyChain 내 사용자 정보 존재"
                        } else {
                            message = "KeyChain 내 사용자 정보 없음(nil)"
                        }
                        
                        Logger.log(
                            message: message,
                            category: .authentication,
                            type: .debug
                        )
                    })
            }
            .map { $0 }
            .withUnretained(self)
            .concatMap { `self`, userAuthInfo in
                guard let _ = userAuthInfo else {
                    return Completable.empty()
                }
                
                return self.keyChainRepository
                    .removeObjectFromKeyChain(forKey: .userAuthInfo)
                    .do(onCompleted: {
                        Logger.log(
                            message: "KeyChain에서 기존 사용자 정보 제거 완료",
                            category: .authentication,
                            type: .debug
                        )
                    })
                    .concat(self.userDefaultsRepository.updateValue(for: .isAppFirstlyLaunched, with: false))
            }
            .asCompletable()
    }
}

private extension DefaultLoginUseCase {
    
    var isAppFirstlyLaunched: Observable<Bool> {
        userDefaultsRepository.getValue(for: .isAppFirstlyLaunched)
            .logErrorIfDetected(category: .database)
            .map { $0 ?? true }
            .catchAndReturn(true)
            .asObservable()
    }
    
    func printConsoleLog(with loginResult: Result<UserAuthInfoEntity?, LoginError>) {
        var message: String
        
        switch loginResult {
        case .success(let authInfo):
            let isSuccess = authInfo != nil
            
            message = """
            \(authInfo?.loginType?.description ?? "N/A") OAuth 로그인 성공 여부: \(isSuccess)
            (false일 경우 생성한 OAuth Access Token에 대한 회원 정보 없기 때문에 신규 가입 필요)
            """
        case .failure(let error):
            message = error.description
        }
        
        Logger.log(
            message: message,
            category: .authentication,
            type: .debug
        )
    }
}
