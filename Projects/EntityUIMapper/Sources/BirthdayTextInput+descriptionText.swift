//
//  BirthdayTextInput+descriptionText.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import DesignSystem

import Utils

public extension BirthdayTextInput.Status {
    var descriptionText: ConditionalTextField.TextFieldStatus {
        switch self {
        case .`default`:
            return ConditionalTextField.TextFieldStatus.`default`(text: LocalizableString.guideToValidDateOfBirthFormat)
        case .defaultWarning:
            return ConditionalTextField.TextFieldStatus.impossible(text: LocalizableString.guideToValidDateOfBirthFormat)
        case .possible:
            return ConditionalTextField.TextFieldStatus.possible(text: LocalizableString.validDateOfBirth)
        case .impossible:
            return ConditionalTextField.TextFieldStatus.impossible(text: LocalizableString.invalidDataOfBirth)
        }
    }
}
