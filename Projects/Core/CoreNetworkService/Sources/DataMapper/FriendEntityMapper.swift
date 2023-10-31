//
//  FriendEntityMapper.swift
//  CoreNetworkService
//
//  Created by Lee, Joon Woo on 2023/10/15.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct FriendEntityMapper: DataMapper {
    public init() { }
    
    public func transform(_ dto: FriendDTO) throws -> FriendEntity {
        guard let profileColor = StoolColor(rawValue: dto.characterColor - 1),
              let profileShape = StoolShape(rawValue: dto.characterShape - 1) else {
            throw NetworkError.dataMappingError
        }
        
        let profile = ProfileCharacter(color: profileColor, shape: profileShape)

        // MARK: 1차 배포 시점에 하이라이팅 안하기 때문에 우선 false로 하드코딩
        return FriendEntity(
            id: dto.id,
            nickname: dto.nickname,
            isActivated: false,
            profile: profile
        )
    }
}
