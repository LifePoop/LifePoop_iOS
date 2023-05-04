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
