//
//  ProfileSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct ProfileSettingModel: SettingModel {
    public let description: String = "프로필 정보"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .textTap
}
