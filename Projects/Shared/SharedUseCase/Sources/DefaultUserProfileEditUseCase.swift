//
//  DefaultUserProfileEditUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public final class DefaultUserProfileEditUseCase: UserProfileEditUseCase {
    
    @Inject(SharedDIContainer.shared) private var profileEditRepository: UserProfileEditRepository
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public init() { }
    
    public func editUserProfile(userProfileEntity: UserProfileEntity) -> Completable {
        return userInfoUseCase
            .userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.profileEditRepository.editUserProfile(
                    accessToken: accessToken,
                    userProfileEntity: userProfileEntity
                )
            }
            .logErrorIfDetected(category: .network)
            .asCompletable()
    }
}
