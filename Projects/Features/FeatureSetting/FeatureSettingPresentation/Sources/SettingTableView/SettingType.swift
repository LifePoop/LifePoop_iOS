//
//  SettingType.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum SettingType: CaseIterable {
    case loginType
    case profile
    case autoLogin
    case version
    case termsOfService
    case privacyPolicy
    case sendFeedback
    
    var model: SettingModel {
        switch self {
        case .loginType:
            return LoginTypeSettingModel()
        case .profile:
            return ProfileSettingModel()
        case .autoLogin:
            return AutoLoginSettingModel()
        case .version:
            return VersionSettingModel()
        case .termsOfService:
            return TermsOfServiceSettingModel()
        case .privacyPolicy:
            return PrivacyPolicySettingModel()
        case .sendFeedback:
            return SendFeedbackSettingModel()
        }
    }
}
