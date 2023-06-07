//
//  OSLog+LogCategory.swift
//  Logger
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation
import OSLog

import Utils

public extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
    
    enum LogCategory {
        case `default`
        case deallocation
        case userDefaults
        case bundle
        case network
        case database
        case authentication
        
        var value: String {
            switch self {
            case .`default`:
                return Constant.OSLogCategory.`default`
            case .bundle:
                return Constant.OSLogCategory.bundle
            case .userDefaults:
                return Constant.OSLogCategory.userDefaults
            case .deallocation:
                return Constant.OSLogCategory.deallocation
            case .network:
                return Constant.OSLogCategory.network
            case .database:
                return Constant.OSLogCategory.database
            case .authentication:
                return Constant.OSLogCategory.authentication
            }
        }
    }
}
