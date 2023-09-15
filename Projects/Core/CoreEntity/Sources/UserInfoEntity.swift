//
//  UserInfoEntity.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserInfoEntity: Codable {
    
    public let userId: Int
    public let nickname: String
    public let authInfo: UserAuthInfoEntity
    
    public init(userId: Int, nickname: String, authInfo: UserAuthInfoEntity) {
        self.userId = userId
        self.nickname = nickname
        self.authInfo = authInfo
    }
}
