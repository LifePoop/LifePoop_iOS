//
//  UserDefaultsError.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public enum UserDefaultsError: LocalizedError {
    case errorDetected(for: UserDefaultsKeys, error: Error)
    case invalidData(for: UserDefaultsKeys)
    
    public var errorDescription: String? {
        switch self {
        case .errorDetected(let userDefaultsKeys, let error):
            return "Error Detected for key: \(userDefaultsKeys.rawKey) - \(error.localizedDescription)"
        case .invalidData(let userDefaultsKeys):
            return "Invalid Data for key: \(userDefaultsKeys.rawKey)"
        }
    }
}
