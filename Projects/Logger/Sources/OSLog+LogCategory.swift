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
        case allocation
        case network
        case database
        
        var value: String {
            switch self {
            case .`default`:
                return Constant.OSLogCategory.`default`
            case .allocation:
                return Constant.OSLogCategory.allocation
            case .network:
                return Constant.OSLogCategory.network
            case .database:
                return Constant.OSLogCategory.database
            }
        }
    }
}
