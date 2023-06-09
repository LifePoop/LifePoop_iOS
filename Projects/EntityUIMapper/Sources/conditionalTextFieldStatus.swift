//
//  NicknameInputStatus+conditionalTextFieldStatus.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import DesignSystem

public extension NicknameInputStatus.Status {
    var conditionalTextFieldStatus: ConditionalTextField.TextFieldStatus {
        switch self {
        case .none(let text):
            return ConditionalTextField.TextFieldStatus.none(text: text)
        case .possible(let text):
            return ConditionalTextField.TextFieldStatus.possible(text: text)
        case .impossible(let text):
            return ConditionalTextField.TextFieldStatus.impossible(text: text)
        }
    }
}
