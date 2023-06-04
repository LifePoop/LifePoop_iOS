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
    
    @Inject(LoginDIContainer.shared) private var loginRepository: LoginRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository

    public init() { }
    
    public func fetchKakaoAuthToken() -> Single<KakaoAuthResultEntity?> {
        return loginRepository.fetchAccessToken(for: .kakao)
            .asObservable()
            .compactMap { $0 as? KakaoAuthResultEntity }
            .asSingle()
            .do(onSuccess: { [weak self] authToken in
                guard let authToken = authToken,
                      let self = self else { return }
                
                let authInfo = UserAuthInfo(loginType: .kakao, authToken: authToken)
                do {
                    try self.keyChainRepository.saveObjectToKeyChain(authInfo, forKey: .userAuthInfo)
                } catch let error {
                    Logger.log(message: "\(error)", category: .authentication, type: .error)
                }
            })
            .logErrorIfDetected(category: .authentication)
    }
    
    public func fetchAppleAuthToken() -> Single<AppleAuthResultEntity?> {
        return loginRepository.fetchAccessToken(for: .apple)
            .asObservable()
            .compactMap { $0 as? AppleAuthResultEntity }
            .asSingle()
            .do(onSuccess: { [weak self] authToken in
                guard let authToken = authToken,
                      let self = self else { return }

                let authInfo = UserAuthInfo(loginType: .apple, authToken: authToken)
                do {
                    try self.keyChainRepository.saveObjectToKeyChain(authInfo, forKey: .userAuthInfo)
                } catch let error {
                    Logger.log(message: "\(error)", category: .authentication, type: .error)
                }
            })
            .logErrorIfDetected(category: .authentication)
    }
}
