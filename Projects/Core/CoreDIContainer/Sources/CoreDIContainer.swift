//
//  CoreDIContainer.swift
//  CoreDIContainer
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public final class CoreDIContainer: DIContainer {
    
    public static let shared = CoreDIContainer()
    
    private init() { }
    
    public var storage: [String: Any] = [:]
}
