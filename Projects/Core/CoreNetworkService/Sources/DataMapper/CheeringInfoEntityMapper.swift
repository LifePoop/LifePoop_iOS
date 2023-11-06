//
//  CheeringInfoEntityMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct CheeringInfoEntityMapper: DataMapper {
    public init() { }
    
    public func transform(_ dto: CheeringInfoDTO) throws -> CheeringInfoEntity {
        return CheeringInfoEntity(
            count: dto.count,
            friends: try dto.thumbs.map {
                guard let color = StoolColor(rawValue: $0.characterColor),
                      let shape = StoolShape(rawValue: $0.characterShape) else {
                    throw NetworkError.dataMappingError
                }
                
                return UserProfileEntity(
                    userId: $0.userId,
                    nickname: $0.nickname,
                    profileCharacter: ProfileCharacter(
                        color: color,
                        shape: shape
                    )
                )
            }
        )
    }
}
