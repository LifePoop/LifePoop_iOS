//
//  SettingModelDisplayTypeMapper.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/23.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

struct SettingModelDisplayTypeMapper {
    static func mapDisplayType(for model: SettingModel) -> SettingInfoDisplayType {
        switch model.type {
        case .loginType:
            return .loginType
        case .version:
            return .text
        case .profile, .termsOfService, .privacyPolicy, .sendFeedback:
            return .tap
        }
    }
}
