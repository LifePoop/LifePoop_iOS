//
//  SharedDIContainer.swift
//  SharedDIContainer
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public final class SharedDIContainer: DIContainer {
    
    public var storage: [String: Any] = [:]
    
    public static let shared = SharedDIContainer()
    
    private init() { }
}
