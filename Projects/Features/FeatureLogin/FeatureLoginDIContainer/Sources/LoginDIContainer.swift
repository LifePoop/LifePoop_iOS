//
//  LoginDIContainer.swift
//  FeatureLoginDIContainer
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//


import Foundation

import Utils

public final class LoginDIContainer: DIContainer {
    
    public var storage: [String: Any] = [:]
    
    public static let shared = LoginDIContainer()
    
    private init() { }
}
