//
//  MockProfileEditUseCase.swift
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

public protocol ProfileEditUseCase {
    func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable
    func checkNicknameValidation(for input: String) -> Observable<NicknameTextInput>
    var profileCharacter: Observable<ProfileCharacter?> { get }
}

public final class MockProfileEditUseCase: ProfileEditUseCase {
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    
    public init() { }
    
    public var profileCharacter: Observable<ProfileCharacter?> {
        return profileCharacterUseCase.profileCharacter
    }
    
    public func checkNicknameValidation(for input: String) -> Observable<NicknameTextInput> {
        return nicknameUseCase.checkNicknameValidation(for: input)
    }
    
    public func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable {
         return Completable.zip(
             nicknameUseCase.updateNickname(to: newNickname),
             profileCharacterUseCase.updateProfileCharacter(to: newProfileCharacter)
         )
         .delay(.milliseconds(1000), scheduler: MainScheduler.asyncInstance) // FIXME: 서버 통신시 delay 삭제
    }
}
