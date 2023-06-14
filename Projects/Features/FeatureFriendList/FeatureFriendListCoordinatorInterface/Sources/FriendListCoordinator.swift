//
//  FriendListCoordinator.swift
//  FeatureFriendListCoordinator
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public protocol FriendListCoordinator: Coordinator {
    func coordinate(by coordinateAction: FriendListCoordinateAction)
}
