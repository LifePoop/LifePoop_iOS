//
//  ToastMessageKind.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/11/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension ToastMessage {
    
    enum ToastMessageKind {
        case success
        case failure
    }
    
    var kind: ToastMessageKind {
        switch self {
        case .auth(let auth):
            switch auth {
            case .fetchAccessTokenSuccess:
                return .success
            case .fetchAccessTokenFail:
                return .failure
            }
        case .friendList(let friendList):
            switch friendList {
            case .fetchFriendListSuccess:
                return .success
            case .fetchFriendListFail:
                return .failure
            }
        case .cheeringInfo(let cheeringInfo):
            switch cheeringInfo {
            case .fetchCheeringInfoSuccess:
                return .success
            case .fetchCheeringInfoFail:
                return .failure
            }
        case .stoolLog(let stoolLog):
            switch stoolLog {
            case .fetchStoolLogSuccess:
                return .success
            case .fetchStoolLogFail:
                return .failure
            case .postStoolLogSuccess:
                return .success
            case .postStoolLogFail:
                return .failure
            }
        case .setting(let setting):
            switch setting {
            case .changeUserProfileSuccess:
                return .success
            case .changeUserProfileFail:
                return .failure
            case .changeNicknameSuccess:
                return .success
            case .changeNicknameFail:
                return .failure
            case .changeProfileCharacterSuccess:
                return .success
            case .changeProfileCharacterFail:
                return .failure
            case .changeFeedVisibilitySuccess:
                return .success
            case .changeFeedVisibilityFail:
                return .failure
            case .changeIsAutoLoginSuccess:
                return .success
            case .changeIsAutoLoginFail:
                return .failure
            }
        case .invitation(let invitation):
            switch invitation {
            case .invitationCodeCopySuccess:
                return .success
            case .invitationCodeCopyFail:
                return .failure
            case .invitationCodeSharingSuccess:
                return .success
            case .invitationCodeSharingFail:
                return .failure
            case .addingFriendSuccess:
                return .success
            case .addingFriendFail:
                return .failure
            }
        }
    }
}
