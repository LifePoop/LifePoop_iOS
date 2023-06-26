//
//  FeedVisibilitySettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public struct FeedVisibilitySettingModel: SettingModel {
    public let description: String = LocalizableString.setUpStoryVisibility
    public let type: SettingType = .feedVisibility
}
