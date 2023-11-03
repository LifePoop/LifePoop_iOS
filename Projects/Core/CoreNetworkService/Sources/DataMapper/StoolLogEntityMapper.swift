//
//  StoolLogEntityMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Utils

public struct StoolLogEntityMapper: DataMapper {
    public init() { }

    public func transform(_ dto: StoolLogDTO) throws -> StoolLogEntity {
        guard let color = StoolColor(rawValue: dto.color),
              let shape = StoolShape(rawValue: dto.shape),
              let size = StoolSize(rawValue: dto.size),
              let date = dto.date.iso8601Date else {
            throw NetworkError.dataMappingError
        }
        
        return StoolLogEntity(
            postID: dto.id,
            date: date,
            isSatisfied: dto.isGood,
            color: color,
            shape: shape,
            size: size
        )
    }
}
