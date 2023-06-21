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

public extension BirthdayTextInput.Status {
    var descriptionText: ConditionalTextField.TextFieldStatus {
        switch self {
        case .`default`:
            return ConditionalTextField.TextFieldStatus.`default`(text: "생년월일 6자를 입력해주세요.")
        case .defaultWarning:
            return ConditionalTextField.TextFieldStatus.impossible(text: "생년월일 6자를 입력해주세요.")
        case .possible:
            return ConditionalTextField.TextFieldStatus.possible(text: "올바른 생년월일이에요.")
        case .impossible:
            return ConditionalTextField.TextFieldStatus.impossible(text: "올바른 생년월일을 입력해주세요.")
        }
    }
}
