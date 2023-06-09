//
//  NicknameInput.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/07.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct NicknameInputStatus {
    
    public enum Status {
        case possible(description: String)
        case impossible(description: String)
        case none(description: String)
    }
    
    public let isValid: Bool
    public let status: Status
    
    public init(isValid: Bool, status: Status) {
        self.isValid = isValid
        self.status = status
    }
}
