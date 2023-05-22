//
//  VersionSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct VersionSettingModel: SettingModel {
    public let description: String = "버전 정보"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .text
}
