//
//  StoryDTO.swift
//  FeatureFriendListCoordinator
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoryDTO: Decodable {
    
    public let id, color, size, shape: Int
    public let date: String
    
    public init(
        id: Int,
        color: Int,
        size: Int,
        shape: Int,
        date: String
    ) {
        self.id = id
        self.color = color
        self.size = size
        self.shape = shape
        self.date = date
    }
}
