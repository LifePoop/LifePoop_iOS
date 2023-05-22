//
//  SettingDIContainer.swift
//  SettingDIContainer
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public final class SettingDIContainer: DIContainer {
    
    public var storage: [String: Any] = [:]
    
    public static let shared = SettingDIContainer()
    
    private init() { }
}
