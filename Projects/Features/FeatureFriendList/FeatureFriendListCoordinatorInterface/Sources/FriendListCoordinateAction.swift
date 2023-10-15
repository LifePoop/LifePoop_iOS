//
//  FriendListCoordinateAction.swift
//  FeatureFriendListCoordinator
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity

public enum FriendListCoordinateAction {
    case showFirendList
    case showFriendInvitation(
        toastMessageStream: PublishRelay<String>,
        friendListUpdateStream: PublishRelay<Void>
    )
    case showInvitationCodePopup(
        type: InvitationType,
        toastMessageStream: PublishRelay<String>,
        friendListUpdateStream: PublishRelay<Void>
    )
    case dismissInvitationCodePopup
}
