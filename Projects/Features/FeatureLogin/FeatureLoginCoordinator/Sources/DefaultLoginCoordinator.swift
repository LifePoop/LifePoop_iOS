//
//  DefaultLoginCoordinator.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem
import FeatureLoginCoordinatorInterface
import FeatureLoginPresentation
import Logger
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
        case .shouldSkipLoginFlow:
            skipFlow()
        case .shouldShowLoginScene:
            showLoginViewController()
        case .shouldShowDetailForm(let title, let detailText):
            showDocumentViewController(title: title, detailText: detailText)
        case .didTapKakaoLoginButton(let authInfo):
            showNicknameViewController(with: authInfo)
        case .didTapAppleLoginButton(let authInfo):
            showNicknameViewController(with: authInfo)
        case .shouldFinishLoginFlow:
            finishFlow()
        case .shouldPopCurrentScene:
            popCurrentViewController()
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultLoginCoordinator {
    
    func showLaunchScreenViewController() {
        let viewController = LaunchScreenViewController()
        let viewModel = LaunchScreenViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showLoginViewController() {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showNicknameViewController(with authInfo: UserAuthInfoEntity) {
        let viewController = SignupViewController()
        let viewModel = SignupViewModel(coordinator: self, authInfo: authInfo)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDocumentViewController(title: String, detailText: String) {
        let viewController = DocumentViewController(title: title, text: detailText)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func skipFlow() {
        flowCompletionDelegate?.skipLoginFlow()
    }
    
    func finishFlow() {
        flowCompletionDelegate?.finishLoginFlow()
    }
    
    func popCurrentViewController() {
        navigationController.popViewController(animated: true)
    }
}
