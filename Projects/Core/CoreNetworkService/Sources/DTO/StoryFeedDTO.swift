//
//  StoryFeedDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoryFeedDTO: Decodable {
    
    public let user: CheeringFriendInfoDTO
    public let stories: [StoryDTO]
    
    public init(user: CheeringFriendInfoDTO, stories: [StoryDTO]) {
        self.user = user
        self.stories = stories
    }
}
