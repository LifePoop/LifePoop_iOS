//
//  Logger.swift
//  Logger
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation
import OSLog

public struct Logger {
    public static func log(message: String, category: OSLog.LogCategory, type: OSLogType) {
        #if DEBUG
        let log = OSLog(subsystem: OSLog.subsystem, category: category.value)
        os_log(type, log: log, "\(message)")
        #endif
    }
    
    public static func logDeallocation<T: AnyObject>(object: T) {
        #if DEBUG
        let log = OSLog(subsystem: OSLog.subsystem, category: OSLog.LogCategory.allocation.value)
        os_log(.info, log: log, "\(T.self) deallocated")
        #endif
    }
}
