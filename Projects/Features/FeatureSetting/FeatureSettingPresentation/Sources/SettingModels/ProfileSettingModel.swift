//
//  ProfileSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public struct ProfileSettingModel: SettingModel {
    public let description: String = LocalizableString.profileInfo
    public let type: SettingType = .profile
}
