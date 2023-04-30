//
//  NetworkError.swift
//  CoreError
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation
import OSLog

public enum NetworkError: LocalizedError {
    case errorDetected(error: Error)
    case objectDeallocated
    case invalidURL
    case invalidResponse
    case invalidStatusCode(code: Int)
    case invalidResponseData
    case invalidRequest
    case decodeError
    case encodeError
    
    public var errorDescription: String? {
        switch self {
        case .errorDetected(let error):
            return "Error detected: \(error.localizedDescription)"
        case .objectDeallocated:
            return "Object Deallocated."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invaild response."
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .invalidResponseData:
            return "Invalid response data."
        case .invalidRequest:
            return "Invalid request."
        case .decodeError:
            return "Fail to decode."
        case .encodeError:
            return "Fail to encode."
        }
    }
}
