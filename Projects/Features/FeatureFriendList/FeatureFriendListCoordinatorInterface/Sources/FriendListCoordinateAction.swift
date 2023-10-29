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
    case shouldShowFirendList
    case shouldShowFriendsStoolLog(friendEntity: FriendEntity)
    case shouldShowFriendInvitation(toastMessageStream: PublishRelay<String>)
    case shouldShowInvitationCodePopup(type: InvitationType, toastMessageStream: PublishRelay<String>)
    case shouldDismissInvitationCodePopup
}
