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
        case `default`
        case possible
        case impossible
        
        public var descriptionText: String {
            switch self {
            case .`default`:
                return "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다."
            case .possible:
                return "사용 가능한 닉네임이에요"
            case .impossible:
                return "사용 불가능한 닉네임이에요"
            }
        }
    }
    
    public let isValid: Bool
    public let status: Status
    
    public init(isValid: Bool, status: Status) {
        self.isValid = isValid
        self.status = status
    }
}
