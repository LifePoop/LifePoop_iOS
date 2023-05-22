//
//  TermsOfServiceSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct TermsOfServiceSettingModel: SettingModel {
    public let description: String = "서비스 이용 약관"
    public let section: SettingListSection = .support
    public let displayType: SettingInfoDisplayType = .tap
}
