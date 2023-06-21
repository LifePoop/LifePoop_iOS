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

public extension NicknameTextInput.Status {
    var descriptionText: ConditionalTextField.TextFieldStatus {
        switch self {
        case .`default`:
            return ConditionalTextField.TextFieldStatus.`default`(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있어요.")
        case .defaultWarning:
            return ConditionalTextField.TextFieldStatus.impossible(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있어요.")
        case .possible:
            return ConditionalTextField.TextFieldStatus.possible(text: "사용 가능한 닉네임이에요.")
        case .impossible:
            return ConditionalTextField.TextFieldStatus.impossible(text: "사용 불가능한 닉네임이에요.")
        }
    }
}
