//
//  DefaultUserInfoUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import Utils

public final class DefaultUserInfoUseCase: UserInfoUseCase {
    
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    
    public init() { }

    public var userInfo: Single<UserInfoEntity> {
        Single.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            do {
                let authInfo = try self.keyChainRepository.getObjectFromKeyChain(
                    asTypeOf: UserInfoEntity.self,
                    forKey: .userAuthInfo
                )
                
                observer(.success(authInfo))
            } catch let error {
                observer(.failure(error))
            }
            
            return Disposables.create { }
        }
    }
    
    // TODO: KeyChain에서 인증정보 가져오기 때문에 해당 함수 수정 혹은 삭제 여부 확인 필요
    public func updateLoginType(to newLoginType: LoginType) {
        userDefaultsRepository.updateValue(for: .userLoginType, with: newLoginType)
    }
}
