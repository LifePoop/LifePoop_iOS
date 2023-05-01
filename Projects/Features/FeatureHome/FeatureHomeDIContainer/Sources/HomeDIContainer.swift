//
//  HomeDIContainer.swift
//  FeatureHomeDIContainer
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public final class HomeDIContainer: DIContainer {
    
    public static let shared = HomeDIContainer()
    
    private init() { }
    
    public var storage: [String: Any] = [:]
}
