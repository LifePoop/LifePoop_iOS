//
//  StoolShape+image.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension StoolShape {
    var deselectedImage: UIImage {
        switch self {
        case .soft:
            return ImageAsset.profileSoftGray.original
        case .good:
            return ImageAsset.profileGoodGray.original
        case .hard:
            return ImageAsset.profileHardGray.original
        }
    }
}
