//
//  OSLoggable.swift
//  Logger
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation
import OSLog

public protocol OSLoggable {
    var category: OSLog.LogCategory { get }
}
