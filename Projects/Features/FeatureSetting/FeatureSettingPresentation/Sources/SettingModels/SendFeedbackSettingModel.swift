//
//  SendFeedbackSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct SendFeedbackSettingModel: SettingModel {
    public let description: String = "의견 보내기"
    public let section: SettingListSection = .support
    public let displayType: SettingInfoDisplayType = .tap
}
