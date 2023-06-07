//
//  StoolColor+image.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension StoolColor {
    var selectedImage: UIImage {
        switch self {
        case .brown:
            return ImageAsset.colorBrownSelected.original
        case .black:
            return ImageAsset.colorBlackSelected.original
        case .pink:
            return ImageAsset.colorPinkSelected.original
        case .green:
            return ImageAsset.colorGreenSelected.original
        case .yellow:
            return ImageAsset.colorYellowSelected.original
        }
    }
    
    var deselectedImage: UIImage {
        switch self {
        case .brown:
            return ImageAsset.colorBrownDeselected.original
        case .black:
            return ImageAsset.colorBlackDeselected.original
        case .pink:
            return ImageAsset.colorPinkDeselected.original
        case .green:
            return ImageAsset.colorGreenDeselected.original
        case .yellow:
            return ImageAsset.colorYellowDeselected.original
        }
    }
}
