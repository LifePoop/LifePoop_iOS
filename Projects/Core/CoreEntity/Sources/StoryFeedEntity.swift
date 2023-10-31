//
//  StoryFeed.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoryFeedEntity {
    public let hashId: UUID = UUID()
    
    public let user: CheeringFriendInfoEntity
    public let stories: [StoryEntity]
    
    public init(user: CheeringFriendInfoEntity, stories: [StoryEntity]) {
        self.user = user
        self.stories = stories
    }
}

extension StoryFeedEntity: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashId == rhs.hashId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashId)
    }
}
