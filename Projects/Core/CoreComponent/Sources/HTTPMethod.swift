//
//  HTTPMethod.swift
//  CoreComponent
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    
    public var value: String {
        return rawValue.uppercased()
    }
}
