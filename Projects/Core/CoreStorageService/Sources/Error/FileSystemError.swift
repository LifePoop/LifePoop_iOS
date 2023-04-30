//
//  FileSystemError.swift
//  CoreStorageService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation
import OSLog

public enum FileSystemError: LocalizedError {
    case errorDetected(error: Error)
    case objectDeallocated
    case invalidFilePath
    case dataNotFound
    
    public var errorDescription: String? {
        switch self {
        case .errorDetected(let error):
            return "Error detected: \(error.localizedDescription)"
        case .objectDeallocated:
            return "Object Deallocated."
        case .invalidFilePath:
            return "Invalid File Path"
        case .dataNotFound:
            return "Fail to Find Data"
        }
    }
}
