//
//  Coordinator.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinatorMap: [CoordinatorType: Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var `type`: CoordinatorType { get }
    
    func start()
}

public extension Coordinator {
    func add(childCoordinator: Coordinator) {
        childCoordinatorMap[childCoordinator.type] = childCoordinator
    }
    
    func remove(childCoordinator type: CoordinatorType) {
        childCoordinatorMap.removeValue(forKey: type)
    }
}
