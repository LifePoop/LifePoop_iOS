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
    
    public let user: UserProfileEntity
    public let stories: [StoryEntity]
    public let isCheered: Bool

    
    public init(user: UserProfileEntity, stories: [StoryEntity], isCheered: Bool) {
        self.user = user
        self.stories = stories
        self.isCheered = isCheered
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
