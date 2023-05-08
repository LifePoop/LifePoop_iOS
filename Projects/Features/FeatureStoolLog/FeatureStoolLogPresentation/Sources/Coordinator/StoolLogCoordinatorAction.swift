//
//  StoolLogCoordinatorAction.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum StoolLogCoordinateAction {
    
    case bottomSheetDidShow
    case didSelectSatisfaction(isSatisfied: Bool)
    case goBack
    case dismissBottomSheet
}
