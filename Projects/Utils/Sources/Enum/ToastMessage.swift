//
//  ToastMessage.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum ToastMessage {
    case auth(Auth)
    case friendList(FriendList)
    case cheeringInfo(CheeringInfo)
    case stoolLog(StoolLog)
    case setting(Setting)
    case invitation(Invitation)
    
    public var localized: String {
        switch self {
        case .auth(let auth):
            switch auth {
            case .fetchAccessTokenSuccess:
                return LocalizableString.toastFetchAccessTokenSuccess
            case .fetchAccessTokenFail:
                return LocalizableString.toastFetchAccessTokenFail
            }
        case .friendList(let friendList):
            switch friendList {
            case .fetchFriendListSuccess:
                return LocalizableString.toastFetchFriendListSuccess
            case .fetchFriendListFail:
                return LocalizableString.toastFetchFriendListFail
            }
        case .cheeringInfo(let cheeringInfo):
            switch cheeringInfo {
            case .fetchCheeringInfoSuccess:
                return LocalizableString.toastFetchCheeringInfoSuccess
            case .fetchCheeringInfoFail:
                return LocalizableString.toastFetchCheeringInfoFail
            }
        case .stoolLog(let stoolLog):
            switch stoolLog {
            case .fetchStoolLogSuccess:
                return LocalizableString.toastFetchStoolLogSuccess
            case .fetchStoolLogFail:
                return LocalizableString.toastFetchStoolLogFail
            case .postStoolLogSuccess:
                return LocalizableString.toastPostStoolLogSuccess
            case .postStoolLogFail:
                return LocalizableString.toastPostStoolLogFail
            }
        case .setting(let setting):
            switch setting {
            case .changeUserProfileSuccess:
                return LocalizableString.toastChangeUserProfileSuccess
            case .changeUserProfileFail:
                return LocalizableString.toastChangeUserProfileFail
            case .changeNicknameSuccess:
                return LocalizableString.toastChangeNicknameSuccess
            case .changeNicknameFail:
                return LocalizableString.toastChangeNicknameFail
            case .changeProfileCharacterSuccess:
                return LocalizableString.toastChangeProfileCharacterSuccess
            case .changeProfileCharacterFail:
                return LocalizableString.toastChangeProfileCharacterFail
            case .changeFeedVisibilitySuccess:
                return LocalizableString.toastChangeFeedVisibilitySuccess
            case .changeFeedVisibilityFail:
                return LocalizableString.toastChangeFeedVisibilityFail
            case .changeIsAutoLoginSuccess:
                return LocalizableString.toastChangeAutoLoginSuccess
            case .changeIsAutoLoginFail:
                return LocalizableString.toastChangeAutoLoginFail
            }
        case .invitation(let invitation):
            switch invitation {
            case .invitationCodeCopySuccess:
                return LocalizableString.toastInvitationCodeCopySuccess
            case .invitationCodeCopyFail:
                return LocalizableString.toastInvitationCodeCopyFail
            case .invitationCodeSharingSuccess:
                return LocalizableString.toastInvitationCodeSharingSuccess
            case .invitationCodeSharingFail:
                return LocalizableString.toastInvitationCodeSharingFail
            case .addingFriendSuccess:
                return LocalizableString.toastAddingFriendSuccess
            case .addingFriendFail(let reason):
                return reason.localized
            }
        }
    }
}

public extension ToastMessage {
    enum Auth {
        case fetchAccessTokenSuccess
        case fetchAccessTokenFail
    }
}

public extension ToastMessage {
    enum FriendList {
        case fetchFriendListSuccess
        case fetchFriendListFail
    }
}

public extension ToastMessage {
    enum CheeringInfo {
        case fetchCheeringInfoSuccess
        case fetchCheeringInfoFail
    }
}

public extension ToastMessage {
    enum StoolLog {
        case fetchStoolLogSuccess
        case fetchStoolLogFail
        case postStoolLogSuccess
        case postStoolLogFail
    }
}

public extension ToastMessage {
    enum Setting {
        case changeUserProfileSuccess
        case changeUserProfileFail
        case changeNicknameSuccess
        case changeNicknameFail
        case changeProfileCharacterSuccess
        case changeProfileCharacterFail
        case changeFeedVisibilitySuccess
        case changeFeedVisibilityFail
        case changeIsAutoLoginSuccess
        case changeIsAutoLoginFail
    }
}

public extension ToastMessage {
    enum Invitation {
        case invitationCodeCopySuccess
        case invitationCodeCopyFail
        case invitationCodeSharingSuccess
        case invitationCodeSharingFail
        case addingFriendSuccess
        case addingFriendFail(reason: AddingFriendFailureReason)
        
        public enum AddingFriendFailureReason {
            case alreadyAddedFriend
            case invalidInvitationCode
            case invalidResult
            
            var localized: String {
                switch self {
                case .alreadyAddedFriend:
                    return LocalizableString.toastAlreadyAddedFriend
                case .invalidInvitationCode:
                    return LocalizableString.toastInvalidInvitationCode
                case .invalidResult:
                    return LocalizableString.toastAddingFriendFail
                }
            }
        }
    }
}
