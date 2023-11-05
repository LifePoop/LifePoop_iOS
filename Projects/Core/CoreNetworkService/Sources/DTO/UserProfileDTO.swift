//
//  UserProfileDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserProfileDTO: Codable {
    let nickname: String
    let characterColor, characterShape: Int
    let isCheered: Bool?
    
    public init(
        nickname: String,
        characterColor: Int,
        characterShape: Int,
        isCheered: Bool? = nil
    ) {
        self.nickname = nickname
        self.characterColor = characterColor
        self.characterShape = characterShape
        self.isCheered = isCheered
    }
}
