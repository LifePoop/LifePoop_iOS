//
//  DefaultLoginCoordinator.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import FeatureLoginCoordinatorInterface
import FeatureLoginPresentation
import Utils

public final class DefaultLoginCoordinator: LoginCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .login
    
    public weak var flowCompletionDelegate: LoginCoordinatorCompletionDelegate?
    
    public init(
        navigationController: UINavigationController,
        flowCompletionDelegate: LoginCoordinatorCompletionDelegate?
    ) {
        self.navigationController = navigationController
        self.flowCompletionDelegate = flowCompletionDelegate
    }
    
    public func start() {
        coordinate(by: .shouldShowLaunchScreen)
    }
    
    public func coordinate(by coordinateAction: LoginCoordinateAction) {
        switch coordinateAction {
        case .shouldShowLaunchScreen:
            showLaunchScreenViewController()
        case .shouldShowLoginScene:
            showLoginViewController()
        case .didTapKakaoLoginButton, .didTapAppleLoginButton:
            showNicknameViewController()
        case .didTapNicknameSetButton:
            finishFlow()
        case .shouldPopCurrentScene:
            popCurrentViewController()
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultLoginCoordinator {
    
    func showLaunchScreenViewController() {
        let viewController = LaunchScreenViewController()
        let viewModel = LaunchScreenViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showLoginViewController() {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showNicknameViewController() {
        let viewController = NicknameViewController()
        let viewModel = NicknameViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finishFlow() {
        flowCompletionDelegate?.showNextFlow()
    }
    
    func popCurrentViewController() {
        navigationController.popViewController(animated: true)
    }
}
