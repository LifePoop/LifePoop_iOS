//
//  UserProfileEntity.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserProfileEntity {
    
    public init(nickname: String, profileCharacter: ProfileCharacter) {
        self.nickname = nickname
        self.profileCharacter = profileCharacter
    }
    
    public let nickname: String
    public let profileCharacter: ProfileCharacter
}
