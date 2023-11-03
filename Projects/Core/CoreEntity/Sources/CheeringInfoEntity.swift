//
//  CheeringInfoEntity.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct CheeringInfoEntity {
    
    public init(count: Int, friends: [UserProfileEntity]) {
        self.count = count
        self.friends = friends
    }
    
    public let count: Int
    public let friends: [UserProfileEntity]
}

public extension CheeringInfoEntity {
    var extraCount: Int {
        return count - 1
    }
    
    var friendName: String? {
        return friends.first?.nickname
    }
    
    var firstFriendProfileCharacter: ProfileCharacter? {
        return friends.first?.profileCharacter
    }
    
    var secondFriendProfileCharacter: ProfileCharacter? {
        return friends.indices.contains(1) ? friends[1].profileCharacter : nil
    }
}
