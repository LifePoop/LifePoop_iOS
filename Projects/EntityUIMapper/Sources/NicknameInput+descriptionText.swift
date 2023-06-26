//
//  NicknameTextInput+descriptionText.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import DesignSystem
import Utils

public extension NicknameTextInput.Status {
    var descriptionText: ConditionalTextField.TextFieldStatus {
        switch self {
        case .`default`:
            return ConditionalTextField.TextFieldStatus.`default`(
                text: LocalizableString.guideToAvailableNicknameFormats
            )
        case .defaultWarning:
            return ConditionalTextField.TextFieldStatus.impossible(
                text: LocalizableString.guideToAvailableNicknameFormats
            )
        case .possible:
            return ConditionalTextField.TextFieldStatus.possible(
                text: LocalizableString.availableNickname
            )
        case .impossible:
            return ConditionalTextField.TextFieldStatus.impossible(
                text: LocalizableString.unavailableNickname
            )
        }
    }
}
