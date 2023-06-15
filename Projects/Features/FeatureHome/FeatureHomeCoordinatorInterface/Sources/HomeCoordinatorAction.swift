//
//  HomeCoordinatorAction.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum HomeCoordinateAction {
    case flowDidStart(animated: Bool)
    case flowDidFinish
    case stoolLogButtonDidTap
    case settingButtonDidTap
}
