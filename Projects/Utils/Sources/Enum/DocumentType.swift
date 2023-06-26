//
//  DocumentType.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum DocumentType {
    case privacyPolicy
    case termsOfService
    
    public var title: String {
        switch self {
        case .privacyPolicy:
            return LocalizableString.privacyPolicy
        case .termsOfService:
            return LocalizableString.termsOfService
        }
    }
    
    public var textFile: TextFile {
        switch self {
        case .privacyPolicy:
            return .privacyPolicy
        case .termsOfService:
            return .termsOfService
        }
    }
}
