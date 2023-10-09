//
//  FriendEntity.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/02.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct FriendEntity {
    public let userID: Int
    public let name: String
    public var isActivated: Bool
    public let profile: ProfileCharacter
    
    public init(
        userID: Int,
        name: String,
        isActivated: Bool,
        profile: ProfileCharacter
    ) {
        self.userID = userID
        self.name = name
        self.isActivated = isActivated
        self.profile = profile
    }
}

extension FriendEntity: Hashable { }

extension FriendEntity {
    public static var dummyData: [FriendEntity] {
        return [
            FriendEntity(userID: 0, name: "김유빈", isActivated: true, profile: .init(color: .brown, shape: .soft)),
            FriendEntity(userID: 1, name: "이화정", isActivated: false, profile: .init(color: .brown, shape: .good)),
            FriendEntity(userID: 2, name: "이준우", isActivated: true, profile: .init(color: .brown, shape: .hard)),
            FriendEntity(userID: 3, name: "강시온", isActivated: false, profile: .init(color: .black, shape: .soft)),
            FriendEntity(userID: 4, name: "손혜정", isActivated: true, profile: .init(color: .black, shape: .good)),
            FriendEntity(userID: 5, name: "김상혁", isActivated: false, profile: .init(color: .black, shape: .hard)),
            FriendEntity(userID: 6, name: "강시온가나", isActivated: true, profile: .init(color: .pink, shape: .soft)),
            FriendEntity(userID: 7, name: "김상혁다라", isActivated: false, profile: .init(color: .pink, shape: .good)),
            FriendEntity(userID: 8, name: "손혜정마바", isActivated: true, profile: .init(color: .pink, shape: .hard)),
            FriendEntity(userID: 9, name: "김유빈사아", isActivated: false, profile: .init(color: .green, shape: .soft)),
            FriendEntity(userID: 10, name: "이준우자차", isActivated: true, profile: .init(color: .green, shape: .good)),
            FriendEntity(userID: 11, name: "이화정카타", isActivated: false, profile: .init(color: .green, shape: .hard)),
            FriendEntity(userID: 12, name: "라이푸12", isActivated: false, profile: .init(color: .yellow, shape: .soft)),
            FriendEntity(userID: 13, name: "LFPOO", isActivated: true, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(userID: 14, name: "12345", isActivated: true, profile: .init(color: .yellow, shape: .hard))
        ]
    }
}
