//
//  NicknameTextInput.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/07.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct NicknameTextInput {
    
    public enum Status {
        case possible
        case defaultWarning
        case impossible
        case `default`
    }
    
    public let isValid: Bool
    public let status: Status
    
    public init(isValid: Bool, status: Status) {
        self.isValid = isValid
        self.status = status
    }
}
