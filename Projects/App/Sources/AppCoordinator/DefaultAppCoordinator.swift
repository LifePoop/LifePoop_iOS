//
//  DefaultAppCoordinator.swift
//  App
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import FeatureFriendListCoordinator
import FeatureFriendListCoordinatorInterface
import FeatureHomeCoordinator
import FeatureHomeCoordinatorInterface
import FeatureLoginCoordinator
import FeatureLoginCoordinatorInterface
import Logger
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
        addNotificationObservers()
    }
    
    public func coordinate(by coordinateAction: AppCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .appDidStart:
                self?.startLoginCoordinatorFlow(showLaunchScreen: true)
            case .authenticationDidReset:
                self?.startLoginCoordinatorFlow(showLaunchScreen: false)
            case .accessTokenDidfetch:
                self?.startHomeCoordinatorFlow(animated: false)
            case .authenticationProcessDidFinish:
                self?.startHomeCoordinatorFlow(animated: true)
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultAppCoordinator {
    func startLoginCoordinatorFlow(showLaunchScreen: Bool) {
        let loginCoordinator = DefaultLoginCoordinator(
            navigationController: navigationController,
            flowCompletionDelegate: self
        )
        add(childCoordinator: loginCoordinator)
        loginCoordinator.start(showLaunchScreen: showLaunchScreen)
    }
    
    func startHomeCoordinatorFlow(animated: Bool) {
        let homeCoordinator = DefaultHomeCoordinator(
            navigationController: navigationController,
            flowCompletionDelegate: self
        )
        add(childCoordinator: homeCoordinator)
        homeCoordinator.start(animated: animated)
    }
}

// MARK: - CompletionDelegate

extension DefaultAppCoordinator: LoginCoordinatorCompletionDelegate {
    public func skipLoginFlow() {
        remove(childCoordinator: .login)
        coordinate(by: .accessTokenDidfetch)
    }
    
    public func finishLoginFlow() {
        remove(childCoordinator: .login)
        coordinate(by: .authenticationProcessDidFinish)
    }
}

extension DefaultAppCoordinator: HomeCoordinatorCompletionDelegate {
    public func finishFlow() {
        remove(childCoordinator: .home)
        coordinate(by: .authenticationDidReset)
    }
}

// MARK: NotificationCenter

private extension DefaultAppCoordinator {
    
    func addNotificationObservers() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetAllChildCoordinators),
            name: .resetLogin,
            object: nil
        )
    }
    
    @objc func resetAllChildCoordinators() {
        if childCoordinatorMap.keys.contains(.login) {
            return
        }
        
        childCoordinatorMap.keys.forEach { key in
            remove(childCoordinator: key)
        }
        
        coordinate(by: .authenticationDidReset)
    }
}
