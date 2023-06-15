//
//  FriendListDIContainer.swift
//  FeatureFriendListDIContainer
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public final class FriendListDIContainer: DIContainer {
    
    public var storage: [String: Any] = [:]
    
    public static let shared = FriendListDIContainer()
    
    private init() { }
}
