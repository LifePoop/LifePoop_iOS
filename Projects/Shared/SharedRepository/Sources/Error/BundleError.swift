//
//  BundleError.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum BundleError: LocalizedError {
    case invalidBundleIdentifier
    case invalidResourcePath
    case invalidInfoDictionaryKey
    case encodingError
    
    public var errorDescription: String? {
        switch self {
        case .invalidBundleIdentifier:
            return "Invalid Bundle Identifier"
        case .invalidResourcePath:
            return "Invalid Resource Path"
        case .invalidInfoDictionaryKey:
            return "Invalid InfoDictionary Key"
        case .encodingError:
            return "Fail to Encode"
        }
    }
}
