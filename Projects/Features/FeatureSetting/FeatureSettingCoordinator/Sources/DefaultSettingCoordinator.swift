//
//  DefaultSettingCoordinator.swift
//  FeatureSettingCoordinator
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxRelay

import CoreEntity
import DesignSystem
import FeatureSettingCoordinatorInterface
import FeatureSettingPresentation
import Logger
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
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .flowDidStart:
                self?.pushSettingViewController()
            case .flowDidFinish:
                self?.completionDelegate?.finishFlow()
            case .profileInfoDidTap(let userNickname):
                self?.pushProfileInfoViewController(with: userNickname)
            case .profileCharacterEditDidTap(let profileCharacter):
                self?.presentProfileEditViewController(with: profileCharacter)
            case .feedVisibilityDidTap(let feedVisibility):
                self?.presentFeedVisibilityViewController(with: feedVisibility)
            case .termsOfServiceDidTap(let title, let text), .privacyPolicyDidTap(let title, let text):
                self?.pushDocumentViewController(with: title, text: text)
            case .sendFeedbackDidTap:
                self?.pushFeedbackViewController()
            case .logOutConfirmButtonDidTap:
                self?.completionDelegate?.finishFlow(by: .userDidLogout)
            case .withdrawConfirmButtonDidTap:
                self?.completionDelegate?.finishFlow(by: .userDidWithdraw)
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
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
    
    func pushProfileInfoViewController(with userNickname: BehaviorRelay<String?>) {
        let viewController = ProfileEditViewController()
        let viewModel = ProfileEditViewModel(coordinator: self, userNickname: userNickname)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentProfileEditViewController(with profileCharacter: BehaviorRelay<ProfileCharacter?>) {
        let viewController = ProfileCharacterEditViewController()
        let viewModel = ProfileCharacterEditViewModel(coordinator: self, profileCharacter: profileCharacter)
        viewController.bind(viewModel: viewModel)
        presentBottomSheetController(contentViewController: viewController, heightRatio: 0.33)
    }
    
    func presentFeedVisibilityViewController(with feedVisibility: BehaviorRelay<FeedVisibility?>) {
        let viewController = FeedVisibilityViewController()
        let viewModel = FeedVisibilityViewModel(coordinator: self, feedVisibility: feedVisibility)
        viewController.bind(viewModel: viewModel)
        presentBottomSheetController(contentViewController: viewController, heightRatio: 0.25)
    }
    
    func pushDocumentViewController(with title: String, text: String?) {
        let viewController = DocumentViewController(title: title, text: text)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushFeedbackViewController() {
        guard let feedbackURL = URL(string: Constant.LifePoopURL.feedback) else { return }
        UIApplication.shared.open(feedbackURL)
    }
}

private extension DefaultSettingCoordinator {
    func presentBottomSheetController(contentViewController: UIViewController, heightRatio: Double) {
        let parentViewController = navigationController
        let bottomSheetController = BottomSheetController(
            bottomSheetHeight: parentViewController.view.bounds.height * heightRatio
        )
        bottomSheetController.setBottomSheet(contentViewController: contentViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)
    }
}
