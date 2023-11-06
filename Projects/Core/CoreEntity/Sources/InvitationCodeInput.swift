//
//  InvitationCodeInput.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/11/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum InvitationCodeInputStatus {
    
    case validInput
    case invalidLength
    case codeOfSelf

    public var isValid: Bool {
        switch self {
        case .validInput:
            return true
        default:
            return false
        }
    }
}
