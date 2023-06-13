//
//  ToastMessage.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum ToastMessage { // TODO: Category별 열거형 분리
    case failToFetchFriendList
    case failToFetchStoolLog
    case failToFetchAccessToken
    case failToFetchImageData
    case setting(SettingToastMessageType)
    
    public var localized: String { // TODO: Localizing
        switch self {
        case .failToFetchFriendList:
            return "친구 목록을 불러오는 데 실패했습니다."
        case .failToFetchStoolLog:
            return "변 기록을 불러오는 데 실패했습니다."
        case .failToFetchAccessToken:
            return "사용자 인증 토큰을 불러오는 데 실패했습니다."
        case .failToFetchImageData:
            return "이미지 데이터를 불러오는 데 실패했습니다."
        case .setting(let settingType):
            switch settingType {
            case .userProfileChangeSucceeded:
                return "프로필 정보가 수정되었습니다."
            case .failToChangeUserProfile:
                return "프로필 정보를 수정하는 데 실패했습니다."
            case .failToChangeNickname:
                return "닉네임 변경을 적용하는 데 실패했습니다."
            case .failToChangeProfileCharacter:
                return "프로필 캐릭터를 변경하는 데 실패했습니다."
            case .failToChangeFeedVisibility:
                return "공개범위 설정을 변경하는 데 실패했습니다."
            case .failToChangeIsAutoLogin:
                return "자동 로그인 설정을 변경하는 데 실패했습니다."
            }
        }
    }
}

public extension ToastMessage {
    enum SettingToastMessageType {
        case userProfileChangeSucceeded
        case failToChangeUserProfile
        case failToChangeNickname
        case failToChangeProfileCharacter
        case failToChangeFeedVisibility
        case failToChangeIsAutoLogin
    }
}
