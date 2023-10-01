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
    }
    
    public func requestAuthInfoWithOAuthAccessToken(
        with oAuthTokenInfo: OAuthTokenInfo
    ) -> Single<UserAuthInfoEntity?> {
        guard let loginType = oAuthTokenInfo.loginType else { return Single.just(nil) }
        
        return urlSessionEndpointService
            .fetchNetworkResult(
                endpoint: LifePoopLocalTarget.login(
                    provider: loginType.description
                ),
                with: ["oAuthAccessToken": oAuthTokenInfo.accessToken]
            )
            .asObservable()
            .withUnretained(self)
            // TODO: 아래 부분 DefaultUserInfoRepository와 중복되므로 추후 개선해야 함
            .map { `self`, networkResult -> UserAuthInfoEntity? in
                let statusCode = networkResult.statusCode
                guard statusCode >= 200 && statusCode < 300 else {
                    throw NetworkError.invalidStatusCode(code: statusCode)
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

                return self.createUpdatedUserAuthInfo(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    loginType: oAuthTokenInfo.loginType
                )
            }
            .asSingle()
            .catchAndReturn(nil)
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
