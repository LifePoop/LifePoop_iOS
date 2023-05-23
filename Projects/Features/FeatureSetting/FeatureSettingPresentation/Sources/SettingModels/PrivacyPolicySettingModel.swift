//
//  PrivacyPolicySettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct PrivacyPolicySettingModel: SettingModel {
    public let description: String = "개인정보 처리 방침"
    public let type: SettingType = .privacyPolicy
}
