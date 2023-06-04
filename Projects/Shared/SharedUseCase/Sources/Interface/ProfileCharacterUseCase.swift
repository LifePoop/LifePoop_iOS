//
//  ProfileCharacterUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol ProfileCharacterUseCase {
    var profileCharacter: BehaviorSubject<ProfileCharacter?> { get }
    func updateProfileCharacter(to newProfileCharacter: ProfileCharacter)
    func updateProfileCharacterColor(
        from existingCharacter: ProfileCharacter,
        to newColor: SelectableColor
    ) -> ProfileCharacter
    func updateProfileCharacterStiffness(
        from existingCharacter: ProfileCharacter,
        to newStiffness: SelectableStiffness
    ) -> ProfileCharacter
}
