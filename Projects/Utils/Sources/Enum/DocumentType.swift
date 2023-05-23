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
            return "개인정보 처리 방침"
        case .termsOfService:
            return "서비스 이용 약관"
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
