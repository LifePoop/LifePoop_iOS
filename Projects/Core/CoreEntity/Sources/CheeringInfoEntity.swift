//
//  CheeringInfoEntity.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct CheeringInfoEntity {
    
    public init(count: Int, friends: [CheeringFriendInfoEntity]) {
        self.count = count
        self.friends = friends
    }
    
    public let count: Int
    public let friends: [CheeringFriendInfoEntity]
}
