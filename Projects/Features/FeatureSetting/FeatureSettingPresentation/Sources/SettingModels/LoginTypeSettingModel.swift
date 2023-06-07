//
//  LoginTypeSettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct LoginTypeSettingModel: SettingModel {
    public let description: String = "로그인 정보"
    public let type: SettingType = .loginType
}
