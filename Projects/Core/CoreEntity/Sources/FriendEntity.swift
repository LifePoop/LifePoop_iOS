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
}

extension FriendEntity: Hashable { }

extension FriendEntity {
    public static var dummyData: [FriendEntity] {
        return [
            FriendEntity(name: "김상혁", isActivated: true),
            FriendEntity(name: "김상혁가가", isActivated: false),
            FriendEntity(name: "김상혁나나", isActivated: false),
            FriendEntity(name: "김상혁다다", isActivated: false),
            FriendEntity(name: "손혜정가가", isActivated: true),
            FriendEntity(name: "손혜정나나나", isActivated: false),
            FriendEntity(name: "손혜정다다다", isActivated: false),
            FriendEntity(name: "이준우가가가", isActivated: false),
            FriendEntity(name: "박서원", isActivated: true),
            FriendEntity(name: "김유빈", isActivated: false),
            FriendEntity(name: "이화정", isActivated: true),
            FriendEntity(name: "김상혁11", isActivated: false),
            FriendEntity(name: "김상혁123", isActivated: false),
            FriendEntity(name: "김상혁123", isActivated: true)
        ]
    }
}
