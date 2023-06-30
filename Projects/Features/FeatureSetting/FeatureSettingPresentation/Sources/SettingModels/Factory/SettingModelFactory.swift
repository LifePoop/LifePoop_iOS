//
//  SettingModelFactory.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/23.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

struct SettingModelFactory {
    static func createModel(for type: SettingType) -> SettingModel {
        switch type {
        case .loginType:
            return LoginTypeSettingModel()
        case .profile:
            return ProfileSettingModel()
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
