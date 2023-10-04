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
    
    enum LoginError: Error {
        case refreshingTokenFailed
    }

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
    public func requestLogin(with oAuthTokenInfo: OAuthTokenInfo) -> Observable<Bool> {
        loginRepository
            .requestAuthInfoWithOAuthAccessToken(with: oAuthTokenInfo)
            .do(onSuccess: { authInfo in
                let isSuccess = authInfo != nil
                
                Logger.log(
                    message: """
                    \(oAuthTokenInfo.loginType?.description ?? "") OAuth 로그인 성공 여부: \(isSuccess)
                    (false일 경우 생성한 OAuth Access Token에 대한 회원 정보 없기 때문에 신규 가입 필요)
                    """,
                    category: .authentication,
                    type: .debug
                )
            })
            .asObservable()
            .withLatestFrom(userInfoUseCase.userInfo) {
                (updatedAuthInfo: $0, originalUserInfo: $1)
            }
            .flatMapLatest { updatedAuthInfo, originalUserInfo -> Observable<Bool> in
                guard let updatedAuthInfo = updatedAuthInfo else {
                    return .just(false)
                }

                let userInfoExists = originalUserInfo != nil
                Logger.log(
                    message: "KeyChain 내 회원정보 존재 확인: \(userInfoExists)",
                    category: .authentication,
                    type: .debug
                )

                if userInfoExists {
                    return .just(true)
                } else {
                    return self.userInfoUseCase.refreshUserInfo(with: updatedAuthInfo)
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
            .flatMapLatest { `self`, _ in
                self.keyChainRepository
                    .getBinaryDataFromKeyChain(
                        forKey: .userAuthInfo,
                        handleExceptionWhenValueNotFound: false
                    )
                    .do(onSuccess: { data in
                        var message: String
                        if let data = data,
                           let dataString = String(data: data, encoding: .utf8) {
                            message = "KeyChain 내 사용자 정보: \(dataString)"
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
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.keyChainRepository
                    .removeObjectFromKeyChain(forKey: .userAuthInfo)
                    .do(onCompleted: {
                        Logger.log(
                            message: "KeyChain에서 기존 사용자 정보 제거 완료",
                            category: .authentication,
                            type: .debug
                        )
                    })
                    .concat(self.userDefaultsRepository
                        .updateValue(
                            for: .isAppFirstlyLaunched,
                            with: false
                        )
                    )
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
