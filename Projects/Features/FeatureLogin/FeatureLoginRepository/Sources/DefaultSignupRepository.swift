//
//  DefaultSignupRepository.swift
//  FeatureLoginRepository
//
//  Created by Lee, Joon Woo on 2023/09/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Utils

public final class DefaultSignupRepository: NSObject, SignupRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
    public override init() { }
    
    public func requestSignup(with signupInput: SignupInput) -> Single<UserAuthInfoEntity> {
        
        var requestBody: [String: String] = [
            "nickname": signupInput.nickname,
            "oAuthAccessToken": signupInput.oAuthAccessToken
        ]
        
        if let birthDate = signupInput.birthDate,
           birthDate.count > 0 {
            requestBody["birth"] = birthDate
        }
        
        if let gender = signupInput.gender {
            requestBody["sex"] = gender.description
        }

        return urlSessionEndpointService
            .fetchNetworkResult(
                endpoint: LifePoopLocalTarget.signup(provider: signupInput.provider.description),
                with: requestBody
            )
            .map { networkResult -> UserAuthInfoEntity in
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

                return try self.createUserAuthInfo(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    loginType: signupInput.provider
                )
            }
            .logErrorIfDetected(category: .network, type: .error)
    }

    private func createUserAuthInfo(accessToken: String?, refreshToken: String?, loginType: LoginType?) throws -> UserAuthInfoEntity {
        guard let accessToken = accessToken,
              let refreshToken = refreshToken,
              let loginType = loginType else {
            throw NetworkError.invalidResponse
        }
        
        return UserAuthInfoEntity(
            loginType: loginType,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
