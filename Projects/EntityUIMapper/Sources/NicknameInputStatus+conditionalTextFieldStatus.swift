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
        case .`default`:
            return ConditionalTextField.TextFieldStatus.`default`(text: descriptionText)
        case .possible:
            return ConditionalTextField.TextFieldStatus.possible(text: descriptionText)
        case .impossible:
            return ConditionalTextField.TextFieldStatus.impossible(text: descriptionText)
        }
    }
}
