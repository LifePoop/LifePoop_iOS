//
//  BirthdayTextInput.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct BirthdayTextInput {
    
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
