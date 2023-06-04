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
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository

    public init() { }
    
    public func saveUserInfo(_ userInfo: UserInfoEntity) -> Single<Void> {
        Single.create { [weak self] observer in

            do {
                try self?.keyChainRepository.saveObjectToKeyChain(userInfo, forKey: .userAuthInfo)
                self?.userDefaultsRepository.updateValue(for: .userNickname, with: userInfo.nickname)
                observer(.success(()))
            } catch let error {
                observer(.failure(error))
            }

            return Disposables.create { }
        }
        .logErrorIfDetected(category: .authentication)

    }
    
    public func fetchUserAuthInfo(for loginType: LoginType) -> Single<UserAuthInfoEntity?> {
        return loginRepository.fetchAccessToken(for: loginType)
            .asObservable()
            .compactMap {
                switch loginType {
                case .apple:
                    return $0 as? AppleAuthResultEntity
                case .kakao:
                    return $0 as? KakaoAuthResultEntity
                }
            }
            .map { UserAuthInfoEntity(loginType: loginType, authToken: $0) }
            .asSingle()
            .logErrorIfDetected(category: .authentication)
    }
}
