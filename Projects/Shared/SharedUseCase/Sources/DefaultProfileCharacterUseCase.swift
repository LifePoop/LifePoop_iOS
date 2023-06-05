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
import Logger
import SharedDIContainer
import Utils

public final class DefaultProfileCharacterUseCase: ProfileCharacterUseCase {
    
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var profileCharacter: Observable<ProfileCharacter?> {
        return userDefaultsRepository
            .getValue(for: .profileCharacter)
            .logErrorIfDetected(category: .userDefaults)
            .asObservable()
    }
    
    public func updateProfileCharacter(to newProfileCharacter: ProfileCharacter) -> Completable {
        return userDefaultsRepository
            .updateValue(for: .profileCharacter, with: newProfileCharacter)
            .logErrorIfDetected(category: .userDefaults)
    }
    
    @discardableResult
    public func updateProfileCharacterColor(
        from existingCharacter: ProfileCharacter,
        to newColor: SelectableColor
    ) -> Completable {
        let newCharacter = ProfileCharacter(color: newColor, stiffness: existingCharacter.stiffness)
        return updateProfileCharacter(to: newCharacter)
    }
    
    @discardableResult
    public func updateProfileCharacterStiffness(
        from existingCharacter: ProfileCharacter,
        to newStiffness: SelectableStiffness
    ) -> Completable {
        let newCharacter = ProfileCharacter(color: existingCharacter.color, stiffness: newStiffness)
        return updateProfileCharacter(to: newCharacter)
    }
}
