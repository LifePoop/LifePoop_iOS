//
//  NetworkResult.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct NetworkResult {
    public let data: Data?
    public let response: HTTPURLResponse
    
    public var statusCode: Int {
        return response.statusCode
    }
    
    public var cookies: [String: String]? {
        guard let allHeaderFields = response.allHeaderFields as? [String: String],
              let url = response.url else { return nil }

        var cookies: [String: String] = [:]
        HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: url).forEach {
            cookies[$0.name] = $0.value
        }
        
        return cookies
    }
    
    public init(data: Data?, response: HTTPURLResponse) {
        self.data = data
        self.response = response
    }
}
