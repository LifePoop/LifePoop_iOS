//
//  StoolColor+color.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension StoolColor {
    var color: UIColor {
        switch self {
        case .brown:
            return ColorAsset.pooBrown.color
        case .black:
            return ColorAsset.pooBlack.color
        case .pink:
            return ColorAsset.pooPink.color
        case .green:
            return ColorAsset.pooGreen.color
        case .yellow:
            return ColorAsset.pooYellow.color
        }
    }
}
