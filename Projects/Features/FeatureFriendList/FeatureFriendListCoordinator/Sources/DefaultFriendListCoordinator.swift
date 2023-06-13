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

    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .friendList
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        coordinate(by: .shouldShowFirendList)
    }
    
    public func coordinate(by coordinateAction: FriendListCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .shouldShowFirendList:
                self?.showFriendListViewController()
            case .shouldShowFriendInvitation:
                self?.showFriendInvitationView()
            }
        }
    }
}

private extension DefaultFriendListCoordinator {
    
    func showFriendListViewController() {
        let viewModel = FriendListViewModel(coordinator: self)
        let viewController = FriendListViewController()
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFriendInvitationView() {
        
        let invitationViewController = FrinedInvitationViewController()
        let invitationViewModel = FriendInvitationViewModel()
        invitationViewController.bind(viewModel: invitationViewModel)
        
        let parentViewController = navigationController
        let bottomSheetController = BottomSheetController(bottomSheetHeight: 255)
        bottomSheetController.setBottomSheet(contentViewController: invitationViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)
    }
}
