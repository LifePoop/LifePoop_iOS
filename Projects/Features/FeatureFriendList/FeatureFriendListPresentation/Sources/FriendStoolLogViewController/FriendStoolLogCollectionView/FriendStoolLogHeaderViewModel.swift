//
//  FriendStoolLogHeaderViewModel.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/11/03.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity

struct FriendStoolLogHeaderViewModel {
    let friendNickname: String
    let cheeringFriendCount: Int
    let firstCheeringCharacter: ProfileCharacter?
    let secondCheeringCharacter: ProfileCharacter?
    
    init(
        friendNickname: String,
        cheeringFriendCount: Int,
        firstCheeringCharacter: ProfileCharacter? = nil,
        secondCheeringCharacter: ProfileCharacter? = nil
    ) {
        self.friendNickname = friendNickname
        self.cheeringFriendCount = cheeringFriendCount
        self.firstCheeringCharacter = firstCheeringCharacter
        self.secondCheeringCharacter = secondCheeringCharacter
    }
}
    
