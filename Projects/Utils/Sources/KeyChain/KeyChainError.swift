//
//  KeyChainError.swift
//  Utils
//
//  Created by 이준우 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum KeyChainError: Error {
    case addingDataFailed(status: OSStatus)
    case gettingDataFailed(status: OSStatus)
    case removingDataFailed(status: OSStatus)
    case nilData(status: OSStatus)
}
