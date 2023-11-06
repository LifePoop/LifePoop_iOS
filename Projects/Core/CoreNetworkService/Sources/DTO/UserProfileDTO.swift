//
//  UserProfileDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserProfileDTO: Codable {
    let userId: Int
    let nickname: String
    let characterColor, characterShape: Int
    let isCheered: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case nickname
        case characterColor
        case characterShape
        case isCheered
    }
    
    public init(
        userId: Int,
        nickname: String,
        characterColor: Int,
        characterShape: Int,
        isCheered: Bool? = nil
    ) {
        self.userId = userId
        self.nickname = nickname
        self.characterColor = characterColor
        self.characterShape = characterShape
        self.isCheered = isCheered
    }
}
