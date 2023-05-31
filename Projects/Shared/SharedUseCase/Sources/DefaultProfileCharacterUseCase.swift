//
//  DefaultProfileCharacterUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import Utils

public final class DefaultProfileCharacterUseCase: ProfileCharacterUseCase {
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var profileCharacter: BehaviorSubject<ProfileCharacter?> {
        return BehaviorSubject<ProfileCharacter?>(value: userDefaultsRepository.getValue(for: .profileCharacter))
    }
    
    public func updateProfileCharacter(to newProfileCharacter: ProfileCharacter) {
        userDefaultsRepository.updateValue(for: .profileCharacter, with: newProfileCharacter)
    }
    
    @discardableResult
    public func updateProfileCharacterColor(
        from existingCharacter: ProfileCharacter,
        to newColor: SelectableColor
    ) -> ProfileCharacter {
        let newCharacter = ProfileCharacter(color: newColor, stiffness: existingCharacter.stiffness)
        updateProfileCharacter(to: newCharacter)
        return newCharacter
    }
    
    @discardableResult
    public func updateProfileCharacterStiffness(
        from existingCharacter: ProfileCharacter,
        to newStiffness: SelectableStiffness
    ) -> ProfileCharacter {
        let newCharacter = ProfileCharacter(color: existingCharacter.color, stiffness: newStiffness)
        updateProfileCharacter(to: newCharacter)
        return newCharacter
    }
}
