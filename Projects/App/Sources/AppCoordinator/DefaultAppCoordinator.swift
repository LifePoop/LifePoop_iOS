//
//  DefaultAppCoordinator.swift
//  App
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import FeatureHomeCoordinator
import FeatureLoginCoordinator
import FeatureLoginCoordinatorInterface
import Utils

public final class DefaultAppCoordinator: AppCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .app
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        coordinate(by: .appDidStart)
    }
    
    public func coordinate(by coordinateAction: AppCoordinateAction) {
        switch coordinateAction {
        case .appDidStart:
            startLoginCoordinatorFlow()
        case .accessTokenDidfetch:
            startHomeCoordinatorFlow()
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultAppCoordinator {
    func startLoginCoordinatorFlow() {
        let loginCoordinator = DefaultLoginCoordinator(
            navigationController: navigationController,
            flowCompletionDelegate: self
        )
        add(childCoordinator: loginCoordinator)
        loginCoordinator.start()
    }
    
    func startHomeCoordinatorFlow() {
        let homeCoordinator = DefaultHomeCoordinator(
            navigationController: navigationController,
            flowCompletionDelegate: self
        )
        add(childCoordinator: homeCoordinator)
        homeCoordinator.start()
    }
}

// MARK: - CompletionDelegate

extension DefaultAppCoordinator: LoginCoordinatorCompletionDelegate {
    public func showNextFlow() {
        remove(childCoordinator: .login)
        coordinate(by: .accessTokenDidfetch)
    }
}

extension DefaultAppCoordinator: HomeCoordinatorCompletionDelegate {
    public func finishFlow() {
        remove(childCoordinator: .home)
        coordinate(by: .appDidStart)
    }
}
