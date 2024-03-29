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
    
    public func start(storyFeedsStream: BehaviorRelay<[StoryFeedEntity]>) {
        coordinate(by: .showFirendList(storyFeedsStream: storyFeedsStream))
    }
    
    // TODO: start 메소드를 Coordinator 프로토콜에서 제외하는 것 고려해보기
    public func start() {
        Logger.log(
            message: "FriendListCoordinator의 start 메소드는 구현되지 않음. start(storyFeedsStream:) 메소드를 사용할 것",
            category: .default,
            type: .default
        )
    }
    
    public func coordinate(by coordinateAction: FriendListCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .showFriendsStoolLog(let friendEntity):
                self?.showFriendStoolLogViewController(of: friendEntity)
            case .showFirendList(let storyFeedsStream):
                self?.showFriendListViewController(storyFeedsStream: storyFeedsStream)
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
    func showFriendListViewController(storyFeedsStream: BehaviorRelay<[StoryFeedEntity]>) {
        let viewModel = FriendListViewModel(coordinator: self, storyFeedsStream: storyFeedsStream)
        let viewController = FriendListViewController()
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFriendStoolLogViewController(of friendEntity: FriendEntity) {
        let viewModel = FriendStoolLogViewModel(
            coordinator: self,
            friendEntity: friendEntity
        )
        let viewController = FriendStoolLogViewController()
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFriendInvitationView(
        toastMessageStream: PublishRelay<ToastMessage>,
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
        toastMessageStream: PublishRelay<ToastMessage>,
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
