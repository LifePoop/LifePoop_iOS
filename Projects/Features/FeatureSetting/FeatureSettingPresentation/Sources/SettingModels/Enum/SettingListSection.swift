//
//  SettingListSection.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public enum SettingListSection: Int {
    case info
    case support
    
    public var title: String {
        switch self {
        case .info:
            return LocalizableString.myInfo
        case .support:
            return LocalizableString.customerSupport
        }
    }
}
