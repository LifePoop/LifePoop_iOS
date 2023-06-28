//
//  VersionSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public struct VersionSettingModel: SettingModel {
    public let description: String = LocalizableString.versionInfo
    public let type: SettingType = .version
}
