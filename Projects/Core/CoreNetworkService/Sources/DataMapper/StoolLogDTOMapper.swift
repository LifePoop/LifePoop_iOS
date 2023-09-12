//
//  StoolLogDTOMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct StoolLogDTOMapper: DataMapper {
    public init() { }

    public func transform(_ entity: StoolLogEntity) throws -> StoolLogDTO {
        return StoolLogDTO(
            postID: entity.postID,
            isGood: entity.isSatisfied,
            color: entity.color.rawValue,
            size: entity.size.rawValue,
            shape: entity.shape.rawValue,
            date: entity.date.iso8601FormatDateString
        )
    }
}
