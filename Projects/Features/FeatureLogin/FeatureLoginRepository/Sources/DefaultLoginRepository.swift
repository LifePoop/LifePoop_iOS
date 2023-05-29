//
//  DefaultLoginRepository.swift
//  FeatureLoginRepository
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import AuthenticationServices

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Utils

public final class DefaultLoginRepository: NSObject, LoginRepository {
    
    public override init() { }
    
    public func fetchKakaoAuthToken() -> Single<KakaoAuthResultEntity> {
        Single.create { [weak self] observer in
            guard UserApi.isKakaoTalkLoginAvailable() else {
                observer(.failure(LoginError.kakaoTalkLoginNotAvailable))
                return Disposables.create { }
            }
            
            UserApi.shared.loginWithKakaoTalk(completion: { token, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let token = token else {
                    observer(.failure(LoginError.authTokenNil))
                    return
                }
                
                let result = KakaoAuthResultEntity(accessToken: token.accessToken, refreshToken: token.refreshToken)
                observer(.success(result))
                
                self?.saveAuthTokenInKeyChain(token.accessToken)
                self?.saveAuthTokenInKeyChain(token.refreshToken)
            })

            return Disposables.create { }
        }
    }
    
    public func fetchAppleAuthToken() -> Single<AppleAuthResultEntity> {
        let appleIdProvider = ASAuthorizationAppleIDProvider()

        return appleIdProvider.rx.login(scope: [.fullName, .email])
            .compactMap { $0.credential as? ASAuthorizationAppleIDCredential }
            .compactMap { $0.identityToken }
            .compactMap { String(data: $0, encoding: .utf8) }
            .map { AppleAuthResultEntity(identityToken: $0) }
            .asSingle()
    }
}

private extension DefaultLoginRepository {

    // 키체인에 저장 처리
    func saveAuthTokenInKeyChain(_ token: String) {
        
    }
}
