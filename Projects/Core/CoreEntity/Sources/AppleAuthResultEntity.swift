//
//  AppleAuthResultEntity.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct AppleAuthResultEntity {
    
    public let identityToken: String
    
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
}
