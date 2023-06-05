//
//  KeyChainError.swift
//  SharedRepository
//
//  Created by Lee, Joon Woo on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Security

public enum KeyChainError: LocalizedError {
    case addingDataFailed(status: OSStatus)
    case gettingDataFailed(status: OSStatus)
    case removingDataFailed(status: OSStatus)
    case nilData(status: OSStatus)
    
    public var errorDescription: String? {
        switch self {
        case .addingDataFailed(let status):
            return "[Status \(status)] Failed to insert data into KeyChain"
        case .gettingDataFailed(let status):
            return "[Status \(status)] Failed to get data from KeyChain"
        case .removingDataFailed(let status):
            return "[Status \(status)] Failed to remove data in KeyChain"
        case .nilData(let status):
            return "[Status \(status)] Loaded data from KeyChain is nil"
        }
    }
}
