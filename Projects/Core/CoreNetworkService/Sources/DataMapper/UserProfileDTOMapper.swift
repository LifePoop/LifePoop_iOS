//
//  UserProfileDTOMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct UserProfileDTOMapper: DataMapper {
    public init() { }

    public func transform(_ entity: UserProfileEntity) throws -> UserProfileDTO {
        return UserProfileDTO(
            nickname: entity.nickname,
            characterColor: entity.profileCharacter.color.rawValue,
            characterShape: entity.profileCharacter.shape.rawValue
        )
    }
}
