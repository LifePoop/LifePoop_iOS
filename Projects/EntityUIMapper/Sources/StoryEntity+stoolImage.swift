//
//  StoryEntity+stoolImage.swift
//  EntityUIMapper
//
//  Created by Lee, Joon Woo on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension StoryEntity {
    
    var stoolImage: UIImage {
        switch (shape, color) {
        case (.good, .black):
            return ImageAsset.stoolLargeGoodBlack.original
        case (.good, .pink):
            return ImageAsset.stoolLargeGoodPink.original
        case (.good, .brown):
            return ImageAsset.stoolLargeGoodBrown.original
        case (.good, .green):
            return ImageAsset.stoolLargeGoodGreen.original
        case (.good, .yellow):
            return ImageAsset.stoolLargeGoodYellow.original
        case (.hard, .black):
            return ImageAsset.stoolLargeHardBlack.original
        case (.hard, .brown):
            return ImageAsset.stoolLargeHardBrown.original
        case (.hard, .green):
            return ImageAsset.stoolLargeHardGreen.original
        case (.hard, .pink):
            return ImageAsset.stoolLargeHardPink.original
        case (.hard, .yellow):
            return ImageAsset.stoolLargeHardYellow.original
        case (.soft, .black):
            return ImageAsset.stoolLargeSoftBlack.original
        case (.soft, .brown):
            return ImageAsset.stoolLargeSoftBrown.original
        case (.soft, .green):
            return ImageAsset.stoolLargeSoftGreen.original
        case (.soft, .pink):
            return ImageAsset.stoolLargeSoftPink.original
        case (.soft, .yellow):
            return ImageAsset.stoolLargeSoftYellow.original
        }
    }
}
