//
//  SettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol SettingModel {
    var description: String { get }
    var section: SettingListSection { get }
    var displayType: SettingInfoDisplayType { get }
}

public struct LoginTypeSettingModel: SettingModel {
    public let description: String = "로그인 정보"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .loginType
}

public struct ProfileSettingModel: SettingModel {
    public let description: String = "프로필 정보"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .textTap
}

public struct AutoLoginSettingModel: SettingModel {
    public let description: String = "자동 로그인 사용"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .switch
}

public struct VersionSettingModel: SettingModel {
    public let description: String = "버전 정보"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .text
}

public struct PrivacyPolicySettingModel: SettingModel {
    public let description: String = "개인정보 처리 방침"
    public let section: SettingListSection = .support
    public let displayType: SettingInfoDisplayType = .tap
}

public struct TermsOfServiceSettingModel: SettingModel {
    public let description: String = "서비스 이용 약관"
    public let section: SettingListSection = .support
    public let displayType: SettingInfoDisplayType = .tap
}

public struct SendFeedbackSettingModel: SettingModel {
    public let description: String = "의견 보내기"
    public let section: SettingListSection = .support
    public let displayType: SettingInfoDisplayType = .tap
}
