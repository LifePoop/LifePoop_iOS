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
    public let birthDate: String?
    public let genderType: GenderType?
    public let profileCharacter: ProfileCharacter
    public let invitationCode: String
    public let authInfo: UserAuthInfoEntity
    
    public init(
        userId: Int,
        nickname: String,
        birthDate: String?,
        genderType: GenderType?,
        profileCharacter: ProfileCharacter,
        invitationCode: String,
        authInfo: UserAuthInfoEntity) {
            
        self.userId = userId
        self.nickname = nickname
        self.birthDate = birthDate
        self.genderType = genderType
        self.profileCharacter = profileCharacter
        self.invitationCode = invitationCode
        self.authInfo = authInfo
    }
}
