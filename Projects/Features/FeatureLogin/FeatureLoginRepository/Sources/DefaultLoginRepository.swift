//
//  DefaultLoginRepository.swift
//  FeatureLoginRepository
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//
import Foundation
import RxSwift

import CoreAuthentication
import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Logger
import Utils

public final class DefaultLoginRepository: NSObject, LoginRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
    public override init() { }
    
    private func authManager(for loginType: LoginType) -> AuthManagable {
        switch loginType {
        case .apple:
            return AppleAuthManager()
        case .kakao:
            return KakaoAuthManager()
        }
    }
   
    public func fetchOAuthAccessToken(for loginType: LoginType) -> Single<String> {
        authManager(for: loginType).fetchAccessToken()
            .logErrorIfDetected(category: .authentication)
            .catch { error in
                guard let error = error as? AuthenticationError else {
                    return .error(error)
                }
                
                let isAuthenticationProcessCancelledByUser =
                    error == .kakaoLoginCancelledByUser
                    || error == .appleLoginViewClosed
                
                if isAuthenticationProcessCancelledByUser {
                    return Single.just("")
                }
                
                return .error(error)
            }
    }
    
    public func requestAuthInfoWithOAuthAccessToken(
        with oAuthTokenInfo: OAuthTokenInfo
    ) -> Single<LoginResult> {
        guard let loginType = oAuthTokenInfo.loginType else { return .just(.failure(loginError: .userNotExists)) }
        
        return urlSessionEndpointService
            .fetchNetworkResult(
                endpoint: LifePoopLocalTarget.login(
                    provider: loginType.description
                ),
                with: ["oAuthAccessToken": oAuthTokenInfo.accessToken]
            )
            .asObservable()
            .withUnretained(self)
            .map { `self`, networkResult in
                let statusCode = networkResult.statusCode
                guard statusCode >= 200 && statusCode < 300 else {
                    switch statusCode {
                    case 400:
                        return .failure(loginError: .oAuthLoginFailed)
                    case 404:
                        return .failure(loginError: .userNotExists)
                    default:
                        throw NetworkError.invalidStatusCode(code: statusCode)
                    }
                }
                
                var accessToken: String?
                var refreshToken: String?
                
                // MARK: AccessToken 추출
                if let bodyData = networkResult.data {
                    let body = try JSONDecoder().decode([String: String].self, from: bodyData)
                    accessToken = body["accessToken"]
                }
                
                // MARK: RefreshToken 추출
                if let cookies = networkResult.cookies {
                    refreshToken = cookies["refresh_token"]
                }

                if let updatedAuthInfo = self.createUpdatedUserAuthInfo(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    loginType: oAuthTokenInfo.loginType
                ) {
                    return .success(authInfo: updatedAuthInfo)
                } else {
                    return .failure(loginError: .updatedAuthInfoNil)
                }
            }
            .asSingle()
    }
}

private extension DefaultLoginRepository {
    
    func createUpdatedUserAuthInfo(
        accessToken: String?,
        refreshToken: String?,
        loginType: LoginType?
    ) -> UserAuthInfoEntity? {
        guard let accessToken = accessToken,
              let refreshToken = refreshToken,
              let loginType = loginType else { return nil }
        
        return UserAuthInfoEntity(
            loginType: loginType,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
