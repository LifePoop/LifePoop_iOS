//
//  SettingType.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

@frozen
public enum SettingType: CaseIterable {
    case loginType
    case profile
    case feedVisibility
    case autoLogin
    case version
    case termsOfService
    case privacyPolicy
    case sendFeedback
}
