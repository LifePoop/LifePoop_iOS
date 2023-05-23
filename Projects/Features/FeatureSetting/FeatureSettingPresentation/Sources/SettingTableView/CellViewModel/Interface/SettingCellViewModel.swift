//
//  SettingCellViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/15.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol SettingCellViewModel: ViewModelType {
    var model: SettingModel { get }
}
