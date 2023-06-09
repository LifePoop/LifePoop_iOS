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
    var profileCharacter: Observable<ProfileCharacter?> { get }
    func updateProfileCharacter(to newProfileCharacter: ProfileCharacter) -> Completable
    func updateProfileCharacterColor(
        from existingCharacter: ProfileCharacter,
        to newColor: StoolColor
    ) -> Completable
    func updateProfileCharacterShape(
        from existingCharacter: ProfileCharacter,
        to newShape: StoolShape
    ) -> Completable
}
