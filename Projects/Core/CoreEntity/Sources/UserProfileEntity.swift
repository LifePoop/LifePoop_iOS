//
//  UserProfileEntity.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserProfileEntity {
    
    public init(userId: Int, nickname: String, profileCharacter: ProfileCharacter) {
        self.userId = userId
        self.nickname = nickname
        self.profileCharacter = profileCharacter
    }
    
    public let userId: Int
    public let nickname: String
    public let profileCharacter: ProfileCharacter
}
