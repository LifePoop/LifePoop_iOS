//
//  AutoLoginSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct AutoLoginSettingModel: SettingModel {
    public let description: String = "자동 로그인 사용"
    public let section: SettingListSection = .info
    public let displayType: SettingInfoDisplayType = .switch
}
