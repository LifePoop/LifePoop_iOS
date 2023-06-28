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
    case home(Home)
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
        case .home(let home):
            switch home {
            case .fetchFriendListSuccess:
                return LocalizableString.toastFetchFriendListSuccess
            case .fetchFriendListFail:
                return LocalizableString.toastFetchFriendListFail
            case .fetchStoolLogSuccess:
                return LocalizableString.toastFetchStoolLogSuccess
            case .fetchStoolLogFail:
                return LocalizableString.toastFetchStoolLogFail
            }
        case .stoolLog(let stoolLog):
            switch stoolLog {
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
            case .invitationCodeSharingSuccess:
                return LocalizableString.toastInvitationCodeSharingSuccess
            case .invitationCodeSharingFail:
                return LocalizableString.toastInvitationCodeSharingFail
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
    enum Home {
        case fetchFriendListSuccess
        case fetchFriendListFail
        case fetchStoolLogSuccess
        case fetchStoolLogFail
    }
}

public extension ToastMessage {
    enum StoolLog {
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
        case invitationCodeSharingSuccess
        case invitationCodeSharingFail
    }
}
