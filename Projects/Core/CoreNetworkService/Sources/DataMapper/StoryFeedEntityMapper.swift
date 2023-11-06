//
//  StoryFeedEntityMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct StoryFeedEntityMapper: DataMapper {
    public init() { }

    public func transform(_ dto: StoryFeedDTO) throws -> StoryFeedEntity {
        guard let color = StoolColor(rawValue: dto.user.characterColor),
              let shape = StoolShape(rawValue: dto.user.characterShape) else {
            throw NetworkError.dataMappingError
        }
        let nickname = dto.user.nickname
        return StoryFeedEntity(
            user: UserProfileEntity(
                userId: dto.user.userId,
                nickname: nickname,
                profileCharacter: ProfileCharacter(
                    color: color,
                    shape: shape
            )),
            stories: try dto.stories.map {
                guard let color = StoolColor(rawValue: $0.color),
                      let size = StoolSize(rawValue: $0.size),
                      let shape = StoolShape(rawValue: $0.shape),
                      let date = $0.date.iso8601Date else {
                    throw NetworkError.dataMappingError
                }
                return StoryEntity(
                    id: $0.id,
                    color: color,
                    size: size,
                    shape: shape,
                    date: date
                )
            }, 
            isCheered: dto.user.isCheered ?? false
        )
    }
}
