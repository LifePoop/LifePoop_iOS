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
    public let isActivated: Bool
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
            FriendEntity(name: "김상혁", isActivated: true, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(name: "김상혁가가", isActivated: false, profile: .init(color: .brown, shape: .soft)),
            FriendEntity(name: "김상혁나나", isActivated: false, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(name: "김상혁다다", isActivated: false, profile: .init(color: .brown, shape: .good)),
            FriendEntity(name: "손혜정가가", isActivated: true, profile: .init(color: .green, shape: .soft)),
            FriendEntity(name: "손혜정나나나", isActivated: false, profile: .init(color: .pink, shape: .good)),
            FriendEntity(name: "손혜정다다다", isActivated: false, profile: .init(color: .black, shape: .good)),
            FriendEntity(name: "이준우가가가", isActivated: false, profile: .init(color: .yellow, shape: .hard)),
            FriendEntity(name: "박서원", isActivated: true, profile: .init(color: .brown, shape: .hard)),
            FriendEntity(name: "김유빈", isActivated: false, profile: .init(color: .green, shape: .good)),
            FriendEntity(name: "이화정", isActivated: true, profile: .init(color: .black, shape: .soft)),
            FriendEntity(name: "김상혁11", isActivated: false, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(name: "김상혁123", isActivated: false, profile: .init(color: .pink, shape: .soft)),
            FriendEntity(name: "김상혁123", isActivated: true, profile: .init(color: .yellow, shape: .good))
        ]
    }
}
