//
//  DefaultHomeCoordinator.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift

import CoreEntity
import DesignSystem
import FeatureFriendListCoordinator
import FeatureFriendListCoordinatorInterface
import FeatureHomeCoordinatorInterface
import FeatureHomePresentation
import FeatureReportPresentation
import FeatureSettingCoordinator
import FeatureSettingCoordinatorInterface
import FeatureStoolLogCoordinator
import Logger
import Utils

public final class DefaultHomeCoordinator: HomeCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .home
    
    public weak var flowCompletionDelegate: HomeCoordinatorCompletionDelegate?
    
    public init(
        navigationController: UINavigationController,
        flowCompletionDelegate: HomeCoordinatorCompletionDelegate?
    ) {
        self.navigationController = navigationController
        self.flowCompletionDelegate = flowCompletionDelegate
    }
    
    public func start(animated: Bool) {
        coordinate(by: .flowDidStart(animated: animated))
    }
        
    public func coordinate(by coordinateAction: HomeCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .flowDidStart(let animated):
                self?.pushHomeViewController(animated: animated)
            case .flowDidFinish:
                self?.flowCompletionDelegate?.finishFlow()
            case .cheeringButtonDidTap:
                self?.startFriendListCoordinatorFlow()
            case .stoolLogButtonDidTap(let stoolLogsRelay):
                self?.startStoolLogCoordinatorFlow(stoolLogsRelay: stoolLogsRelay)
            case .settingButtonDidTap:
                self?.startSettingCoordinatorFlow()
            case .reportButtonDidTap:
                self?.pushReportViewController()
            case .storyFeedButtonDidTap(let friendUserId, let stories, let isCheered):
                self?.presentFriendStoolStoryViewController(
                    friendUserId: friendUserId,
                    stories: stories,
                    isCheered: isCheered,
                    animated: true
                )
            case .storyCloseButtonDidTap:
                self?.dismissFriendStoolStoryViewController(animated: true)
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {
    func pushHomeViewController(animated: Bool) {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func presentFriendStoolStoryViewController(
        friendUserId: Int,
        stories: [StoryEntity],
        isCheered: Bool,
        animated: Bool
    ) {
        let viewModel = FriendStoolStoryViewModel(
            coordinator: self,
            friendUserId: friendUserId,
            stories: stories,
            isCheered: isCheered
        )
        let viewController = FriendStoolStoryViewController()
        viewController.bind(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: animated)
    }
    
    func dismissFriendStoolStoryViewController(animated: Bool) {
        navigationController.presentedViewController?.dismiss(animated: animated)
    }
    
    func startStoolLogCoordinatorFlow(stoolLogsRelay: BehaviorRelay<[StoolLogEntity]>) {
        let stoolLogCoordinator = DefaultStoolLogCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self,
            stoolLogsRelay: stoolLogsRelay
        )
        add(childCoordinator: stoolLogCoordinator)

        let bottomSheetController = presentBottomSheetController(
            contentViewController: stoolLogCoordinator.navigationController
        )
        bottomSheetController.delegate = stoolLogCoordinator
        stoolLogCoordinator.start()
    }
    
    func startSettingCoordinatorFlow() {
        let settingCoordinator = DefaultSettingCoordinator(
            navigationController: navigationController,
            completionDelegate: self
        )
        add(childCoordinator: settingCoordinator)
        settingCoordinator.start()
    }
    
    func pushReportViewController() {
        let viewController = ReportViewController()
        let viewModel = ReportViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startFriendListCoordinatorFlow() {
        let friendListCoordinator = DefaultFriendListCoordinator(navigationController: navigationController)
        add(childCoordinator: friendListCoordinator)
        friendListCoordinator.start()
    }
}

// MARK: - Supporting Methods

private extension DefaultHomeCoordinator {
    
    func presentBottomSheetController(contentViewController: UIViewController) -> BottomSheetController {
        let parentViewController = navigationController
        let bottomSheetController = BottomSheetController(
            bottomSheetHeight: 420
        )
        
        bottomSheetController.setBottomSheet(contentViewController: contentViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)

        return bottomSheetController
    }
}

// MARK: - Adopt Coordinator Completion Delegate

extension DefaultHomeCoordinator: SettingCoordinatorCompletionDelegate {
    public func finishFlow() {
        remove(childCoordinator: .setting)
    }
    
    public func finishFlow(by completion: SettingFlowCompletion) {
        remove(childCoordinator: .setting)
        switch completion {
        case .userDidWithdraw, .userDidLogout:
            flowCompletionDelegate?.finishFlow()
        }
    }
}
