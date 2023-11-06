//
//  DefaultProfileEditUseCase.swift
//  FeatureSettingUseCase
//
//  Created by 김상혁 on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultProfileEditUseCase: ProfileEditUseCase {
    
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    @Inject(SharedDIContainer.shared) private var userProfileEditUseCase: UserProfileEditUseCase
    
    public init() { }
    
    public var profileCharacter: Observable<ProfileCharacter?> {
        return profileCharacterUseCase.profileCharacter
    }
    
    public func updateNickname(to newNickname: String) -> Completable {
        return nicknameUseCase.updateNickname(to: newNickname)
    }
    
    public func checkNicknameValidation(for input: String) -> Observable<NicknameTextInput> {
        return nicknameUseCase.checkNicknameValidation(for: input)
    }
    
    public func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable {
        
        let newUserProfile = userInfoUseCase.userInfo
            .compactMap { $0?.userId }
            .map { userId in
                UserProfileEntity(
                    userId: userId,
                    nickname: newNickname,
                    profileCharacter: newProfileCharacter
                )
            }
        
        return newUserProfile
            .withUnretained(self)
            .flatMap { $0.userProfileEditUseCase.editUserProfile(userProfileEntity: $1) }
            .asCompletable()
            .andThen(
                Completable.zip(
                    nicknameUseCase.updateNickname(to: newNickname),
                    profileCharacterUseCase.updateProfileCharacter(to: newProfileCharacter)
                )
            )
    }
}
