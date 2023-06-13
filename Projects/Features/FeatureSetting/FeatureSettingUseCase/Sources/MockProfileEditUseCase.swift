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

enum MockError: LocalizedError {
    case failToEditProfile
    
    var errorDescription: String? {
        switch self {
        case .failToEditProfile:
            return "Profile Edit Error (Mock)"
        }
    }
}

public protocol ProfileEditUseCase {
    func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable
    func checkNicknameValidation(for input: String) -> Observable<NicknameInputStatus>
    var profileCharacter: Observable<ProfileCharacter?> { get }
}

public final class MockProfileEditUseCase: ProfileEditUseCase {
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    
    public init() { }
    
    public var profileCharacter: Observable<ProfileCharacter?> {
        return profileCharacterUseCase.profileCharacter
    }
    
    public func checkNicknameValidation(for input: String) -> Observable<NicknameInputStatus> {
        return nicknameUseCase.checkNicknameValidation(for: input)
    }
    
    public func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable {
        // Success
//         return Completable.zip(
//             nicknameUseCase.updateNickname(to: newNickname),
//             profileCharacterUseCase.updateProfileCharacter(to: newProfileCharacter)
//         )
//         .delay(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
        
//         Failure
         let errorAfterOneSecond: Completable = Completable.create { completable in
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                 completable(.error(MockError.failToEditProfile))
             }
             return Disposables.create()
         }
         return errorAfterOneSecond.logErrorIfDetected(category: .network)
        
    }
}
