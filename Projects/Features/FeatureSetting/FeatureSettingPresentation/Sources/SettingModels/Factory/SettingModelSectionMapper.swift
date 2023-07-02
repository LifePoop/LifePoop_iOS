//
//  SettingModelSectionMapper.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/23.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

struct SettingModelSectionMapper {
    static func mapSection(for model: SettingModel) -> SettingListSection {
        switch model.type {
        case .loginType, .profile, .version:
            return .info
        case .termsOfService, .privacyPolicy, .sendFeedback:
            return .support
        }
    }
}
