//
//  TextFile.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum TextFile: String {
    case privacyPolicy = "PrivacyPolicy"
    case termsOfService = "TermsOfService"
    
    public var name: String {
        return rawValue
    }
}
