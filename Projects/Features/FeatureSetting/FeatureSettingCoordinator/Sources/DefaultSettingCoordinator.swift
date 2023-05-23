//
//  DefaultSettingCoordinator.swift
//  FeatureSettingCoordinator
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem
import FeatureSettingCoordinatorInterface
import FeatureSettingPresentation
import Utils

public final class DefaultSettingCoordinator: SettingCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .setting
    
    public weak var completionDelegate: SettingCoordinatorCompletionDelegate?
    
    public init(
        navigationController: UINavigationController,
        completionDelegate: SettingCoordinatorCompletionDelegate?
    ) {
        self.navigationController = navigationController
        self.completionDelegate = completionDelegate
    }
    
    public func start() {
        coordinate(by: .flowDidStart)
    }
    
    public func coordinate(by coordinateAction: SettingCoordinateAction) {
        switch coordinateAction {
        case .flowDidStart:
            pushSettingViewController()
        case .flowDidFinish:
            completionDelegate?.finishFlow()
        case .profileInfoDidTap:
            pushProfileInfoViewController()
        case .termsOfServiceDidTap(let title, let text), .privacyPolicyDidTap(let title, let text):
            pushDocumentViewController(with: title, text: text)
        case .sendFeedbackDidTap:
            pushFeedbackViewController()
        case .withdrawButtonDidTap:
            pushWithdrawalViewController()
        case .logOutConfirmButtonDidTap, .withdrawConfirmButtonDidTap:
            startLoginCoordinatorFlow()
        }
    }
    
    deinit {
        print("\(self) - \(#function)") // TODO: import Logger
    }
}

// MARK: - Coordinating Methods

private extension DefaultSettingCoordinator {
    func pushSettingViewController() {
        let viewController = SettingViewController()
        let viewModel = SettingViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushProfileInfoViewController() {
        let viewController = ProfileViewController()
        let viewModel = ProfileViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushDocumentViewController(with title: String, text: String?) {
        let viewController = DocumentViewController(title: title, text: text)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushFeedbackViewController() {
        let viewController = FeedbackViewController()
        let viewModel = FeedbackViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushWithdrawalViewController() {
        let viewController = WithdrawalViewController()
        let viewModel = WithdrawalViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startLoginCoordinatorFlow() {
        print(#function)
    }
}
