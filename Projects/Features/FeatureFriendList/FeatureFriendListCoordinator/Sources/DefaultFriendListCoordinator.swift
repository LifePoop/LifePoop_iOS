//
//  DefaultFriendListCoordinator.swift
//  FeatureFriendListCoordinator
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem
import FeatureFriendListCoordinatorInterface
import FeatureFriendListPresentation
import Utils

public final class DefaultFriendListCoordinator: FriendListCoordinator {

    public var childCoordinatorMap: [CoordinatorType : Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .friendList
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
    }
    
    public func coordinate(by coordinateAction: FriendListCoordinateAction) {
        
    }
    
    
    
    
    
    
}
