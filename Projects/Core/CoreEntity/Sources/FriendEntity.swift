//
//  FriendEntity.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/02.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct FriendEntity {
    public let name: String
    public var isActivated: Bool
    public let profile: ProfileCharacter
    
    public init(name: String, isActivated: Bool, profile: ProfileCharacter) {
        self.name = name
        self.isActivated = isActivated
        self.profile = profile
    }
}

extension FriendEntity: Hashable { }

extension FriendEntity {
    public static var dummyData: [FriendEntity] {
        return [
            FriendEntity(name: "김유빈", isActivated: true, profile: .init(color: .brown, shape: .soft)),
            FriendEntity(name: "이화정", isActivated: false, profile: .init(color: .brown, shape: .good)),
            FriendEntity(name: "이준우", isActivated: true, profile: .init(color: .brown, shape: .hard)),
            FriendEntity(name: "강시온", isActivated: false, profile: .init(color: .black, shape: .soft)),
            FriendEntity(name: "손혜정", isActivated: true, profile: .init(color: .black, shape: .good)),
            FriendEntity(name: "김상혁", isActivated: false, profile: .init(color: .black, shape: .hard)),
            FriendEntity(name: "강시온가나", isActivated: true, profile: .init(color: .pink, shape: .soft)),
            FriendEntity(name: "김상혁다라", isActivated: false, profile: .init(color: .pink, shape: .good)),
            FriendEntity(name: "손혜정마바", isActivated: true, profile: .init(color: .pink, shape: .hard)),
            FriendEntity(name: "김유빈사아", isActivated: false, profile: .init(color: .green, shape: .soft)),
            FriendEntity(name: "이준우자차", isActivated: true, profile: .init(color: .green, shape: .good)),
            FriendEntity(name: "이화정카타", isActivated: false, profile: .init(color: .green, shape: .hard)),
            FriendEntity(name: "라이푸12", isActivated: false, profile: .init(color: .yellow, shape: .soft)),
            FriendEntity(name: "LFPOO", isActivated: true, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(name: "12345", isActivated: true, profile: .init(color: .yellow, shape: .hard))
        ]
    }
}
