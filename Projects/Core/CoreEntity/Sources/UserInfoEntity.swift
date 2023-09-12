//
//  UserInfoEntity.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserInfoEntity: Codable {
    
    public let nickname: String //FIXME: userID로 변경
    public let authInfo: UserAuthInfoEntity
    
    public init(nickname: String, authInfo: UserAuthInfoEntity) {
        self.nickname = nickname
        self.authInfo = authInfo
    }
}
