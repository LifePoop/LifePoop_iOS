//
//  DefaultFriendListCoordinator.swift
//  FeatureFriendListCoordinator
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift

import CoreEntity
import DesignSystem
import FeatureFriendListCoordinatorInterface
import FeatureFriendListPresentation
import Utils

public final class DefaultFriendListCoordinator: FriendListCoordinator {

    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .friendList
    
    private weak var bottomSheetController: BottomSheetController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        coordinate(by: .shouldShowFirendList)
    }
    
    public func coordinate(by coordinateAction: FriendListCoordinateAction) {
        switch coordinateAction {
        case .shouldShowFirendList:
            showFriendListViewController()
        case .shouldShowFriendInvitation(let toastMessageStream):
            showFriendInvitationView(with: toastMessageStream)
        case .shouldShowInvitationCodePopup(let invitationType, let toastMessageStream):
            showInvitationCodePopup(invitationType: invitationType, toastMessageStream: toastMessageStream)
        case .shouldDismissInvitationCodePopup:
            dismissViewController()
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
    
    func showFriendInvitationView(with toastMessageStream: PublishRelay<String>) {
        
        let invitationViewController = FrinedInvitationViewController()
        let invitationViewModel = FriendInvitationViewModel(coordinator: self, toastMessageStream: toastMessageStream)
        invitationViewController.bind(viewModel: invitationViewModel)
        
        let parentViewController = navigationController
        let bottomSheetController = BottomSheetController(bottomSheetHeight: 255)
        bottomSheetController.setBottomSheet(contentViewController: invitationViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)
        
        self.bottomSheetController = bottomSheetController
    }
    
    func showInvitationCodePopup(invitationType: InvitationType, toastMessageStream: PublishRelay<String>) {
        closeBottomSheet()
        
        let invitationCodeViewController = InvitationCodeViewController()
        let invitationCodeViewModel = InvitationCodeViewModel(
            coordinator: self,
            invitationType: invitationType,
            toastMessageStream: toastMessageStream
        )
        invitationCodeViewController.bind(viewModel: invitationCodeViewModel)
        
        invitationCodeViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(invitationCodeViewController, animated: false)
    }
    
    // TODO: presentedViewController에 TransparentBackgroundViewController 남아있는 부분 개선 필요
    func closeBottomSheet() {
        bottomSheetController?.closeBottomSheet()
        navigationController.presentedViewController?.dismiss(animated: false)
    }
    
    func dismissViewController() {
        navigationController.presentedViewController?.dismiss(animated: false)
    }
}
