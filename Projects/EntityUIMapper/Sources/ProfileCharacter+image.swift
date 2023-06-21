//
//  ProfileCharacter+image.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension ProfileCharacter {
    var image: UIImage {
        switch (shape, color) {
        case (.good, .black):
            return ImageAsset.profileGoodBlack.original
        case (.good, .pink):
            return ImageAsset.profileGoodRed.original
        case (.good, .brown):
            return ImageAsset.profileGoodBrown.original
        case (.good, .green):
            return ImageAsset.profileGoodGreen.original
        case (.good, .yellow):
            return ImageAsset.profileGoodYellow.original
        case (.hard, .black):
            return ImageAsset.profileHardBlack.original
        case (.hard, .brown):
            return ImageAsset.profileHardBrown.original
        case (.hard, .green):
            return ImageAsset.profileHardGreen.original
        case (.hard, .pink):
            return ImageAsset.profileHardRed.original
        case (.hard, .yellow):
            return ImageAsset.profileHardYellow.original
        case (.soft, .black):
            return ImageAsset.profileSoftBlack.original
        case (.soft, .brown):
            return ImageAsset.profileSoftBrown.original
        case (.soft, .green):
            return ImageAsset.profileSoftGreen.original
        case (.soft, .pink):
            return ImageAsset.profileSoftRed.original
        case (.soft, .yellow):
            return ImageAsset.profileSoftYellow.original
        }
    }
    
    var highlightedImage: UIImage {
        switch (shape, color) {
        case (.good, .black):
            return ImageAsset.profileGoodBlackHighlighted.original
        case (.good, .pink):
            return ImageAsset.profileGoodRedHighlighted.original
        case (.good, .brown):
            return ImageAsset.profileGoodBrownHighlighted.original
        case (.good, .green):
            return ImageAsset.profileGoodGreenHighlighted.original
        case (.good, .yellow):
            return ImageAsset.profileGoodYellowHighlighted.original
        case (.hard, .black):
            return ImageAsset.profileHardBlackHighlighted.original
        case (.hard, .brown):
            return ImageAsset.profileHardBrownHighlighted.original
        case (.hard, .green):
            return ImageAsset.profileHardGreenHighlighted.original
        case (.hard, .pink):
            return ImageAsset.profileHardRedHighlighted.original
        case (.hard, .yellow):
            return ImageAsset.profileHardYellowHighlighted.original
        case (.soft, .black):
            return ImageAsset.profileSoftBlackHighlighted.original
        case (.soft, .brown):
            return ImageAsset.profileSoftBrownHighlighted.original
        case (.soft, .green):
            return ImageAsset.profileSoftGreenHighlighted.original
        case (.soft, .pink):
            return ImageAsset.profileSoftRedHighlighted.original
        case (.soft, .yellow):
            return ImageAsset.profileSoftYellowHighlighted.original
        }
    }
}
