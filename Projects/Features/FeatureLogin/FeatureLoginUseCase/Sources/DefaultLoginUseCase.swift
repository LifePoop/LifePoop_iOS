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
            .log(message: "기기에 기존 인증정보 존재 확인", category: .authentication, printElement: true)
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                if let authInfo = userInfo?.authInfo {
                    return self.userInfoUseCase.refreshAuthInfo(with: authInfo)
                } else {
                    return Observable.just(false)
                }
            }
    }

    /** OAuth 토큰 정보로 Lifepoo Access Token, Refresh Token 획득 및 로그인 처리 요청 */
    public func requestLogin(with oAuthTokenInfo: OAuthTokenInfo) -> Observable<Bool> {
        loginRepository
            .requestAuthInfoWithOAuthAccessToken(with: oAuthTokenInfo)
            .log(message: "OAuth 로그인 요청 결과:", category: .authentication, printElement: true)
            .asObservable()
            .withLatestFrom(userInfoUseCase.userInfo) {
                (loginResult: $0, userInfoExists: $1 != nil)
            }
            .flatMapLatest { [weak self] loginResult, userInfoExists -> Observable<Bool> in
                guard let `self` = self else { return .just(false) }
                
                switch loginResult {
                case .success(let updatedAuthInfo):
                    if userInfoExists {
                        return .just(true)
                    } else {
                        return self.userInfoUseCase.fetchUserInfo(with: updatedAuthInfo)
                    }
                case .failure(let loginError):
                    switch loginError {
                    case .userNotExists:
                        return .just(false)
                    default:
                        return .error(loginError)
                    }
                }
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
    }
    
    public func clearUserAuthInfoIfLaunchedFirstly() -> Completable {
        isAppFirstlyLaunched
            .log(message: "앱 설치 후 최초 기동", category: .authentication, printElement: true)
            .filter { $0 }
            .withUnretained(self)
            .concatMap { `self`, _ in
                self.keyChainRepository
                    .getBinaryDataFromKeyChain(
                        forKey: .userAuthInfo,
                        handleExceptionWhenValueNotFound: false
                    )
                    .log(message: "KeyChain 내 사용자 정보 존재 확인", category: .authentication, printElement: true)
            }
            .map { $0 }
            .withUnretained(self)
            .concatMap { `self`, userAuthInfo in
                guard let _ = userAuthInfo else {
                    return Completable.empty()
                }
                
                return self.keyChainRepository
                    .removeObjectFromKeyChain(forKey: .userAuthInfo)
                    .log(message: "KeyChain에서 기존 사용자 정보 제거 완료", category: .authentication)
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
}
