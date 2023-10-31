//
//  StoryEntity.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoryEntity {
    
    public let id: Int
    public let color: StoolColor
    public let size: StoolSize
    public let shape: StoolShape
    public let date: Date
    
    public init(
        id: Int,
        color: StoolColor,
        size: StoolSize,
        shape: StoolShape,
        date: Date
    ) {
        self.id = id
        self.color = color
        self.size = size
        self.shape = shape
        self.date = date
    }
}
