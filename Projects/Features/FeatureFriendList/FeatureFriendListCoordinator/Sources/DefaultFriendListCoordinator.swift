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
import Logger
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
        coordinate(by: .showFirendList)
    }
    
    public func coordinate(by coordinateAction: FriendListCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .showFirendList:
                self?.showFriendListViewController()
            case .showFriendInvitation(let toastMessageStream, let friendListUpdateStream):
                self?.showFriendInvitationView(
                    toastMessageStream: toastMessageStream,
                    friendListUpdateStream: friendListUpdateStream
                )
            case .showInvitationCodePopup(let invitationType, let toastMessageStream, let friendListUpdateStream):
                self?.showInvitationCodePopup(
                    invitationType: invitationType,
                    toastMessageStream: toastMessageStream,
                    friendListUpdateStream: friendListUpdateStream
                )
            case .dismissInvitationCodePopup:
                self?.dismissViewController()
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

private extension DefaultFriendListCoordinator {
    
    func showFriendListViewController() {
        let viewModel = FriendListViewModel(coordinator: self)
        let viewController = FriendListViewController()
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFriendInvitationView(
        toastMessageStream: PublishRelay<String>,
        friendListUpdateStream: PublishRelay<Void>
    ) {
        
        let invitationViewController = FrinedInvitationViewController()
        let invitationViewModel = FriendInvitationViewModel(
            coordinator: self,
            toastMessageStream: toastMessageStream,
            friendListUpdateStream: friendListUpdateStream
        )
        invitationViewController.bind(viewModel: invitationViewModel)
        
        let parentViewController = navigationController
        let bottomSheetController = BottomSheetController(bottomSheetHeight: 255)
        bottomSheetController.setBottomSheet(contentViewController: invitationViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)
        
        self.bottomSheetController = bottomSheetController
    }
    
    func showInvitationCodePopup(
        invitationType: InvitationType,
        toastMessageStream: PublishRelay<String>,
        friendListUpdateStream: PublishRelay<Void>
    ) {
        closeBottomSheet()
        
        let invitationCodeViewController = InvitationCodeViewController()
        let invitationCodeViewModel = InvitationCodeViewModel(
            coordinator: self,
            invitationType: invitationType,
            toastMessageStream: toastMessageStream,
            friendListUpdateStream: friendListUpdateStream
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
