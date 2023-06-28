//
//  AutoLoginSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public struct AutoLoginSettingModel: SettingModel {
    public let description: String = LocalizableString.setUpAutomaticSignIn
    public let type: SettingType = .autoLogin
}
