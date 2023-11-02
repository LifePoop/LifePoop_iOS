//
//  ProfileEditUseCase.swift
//  FeatureSettingUseCase
//
//  Created by 김상혁 on 2023/11/02.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol ProfileEditUseCase {
    var profileCharacter: Observable<ProfileCharacter?> { get }
    func checkNicknameValidation(for input: String) -> Observable<NicknameTextInput>
    func updateProfileInfo(newProfileCharacter: ProfileCharacter, newNickname: String) -> Completable
}
