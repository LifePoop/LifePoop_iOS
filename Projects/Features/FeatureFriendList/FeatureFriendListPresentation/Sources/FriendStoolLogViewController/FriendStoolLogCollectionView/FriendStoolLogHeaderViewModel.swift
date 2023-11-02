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
    let isStoolLogEmpty: Bool
    let cheeringFriendCount: Int
    let firstCheeringCharacter: ProfileCharacter?
    let secondCheeringCharacter: ProfileCharacter?
    
    init(
        friendNickname: String,
        isStoolLogEmpty: Bool,
        cheeringFriendCount: Int,
        firstCheeringCharacter: ProfileCharacter?,
        secondCheeringCharacter: ProfileCharacter?
    ) {
        self.friendNickname = friendNickname
        self.isStoolLogEmpty = isStoolLogEmpty
        self.cheeringFriendCount = cheeringFriendCount
        self.firstCheeringCharacter = firstCheeringCharacter
        self.secondCheeringCharacter = secondCheeringCharacter
    }
}
    
