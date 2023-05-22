//
//  SettingModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol SettingModel {
    var description: String { get }
    var section: SettingListSection { get }
    var displayType: SettingInfoDisplayType { get }
}
