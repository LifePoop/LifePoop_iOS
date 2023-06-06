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

public extension ProfileCharacter { // FIXME: Rename: stifness -> type / case stiffness -> case hard
    var image: UIImage {
        switch (stiffness, color) {
        case (.normal, .black):
            return ImageAsset.profileGoodBlack.original
        case (.normal, .pink):
            return ImageAsset.profileGoodRed.original
        case (.normal, .brown):
            return ImageAsset.profileGoodBrown.original
        case (.normal, .green):
            return ImageAsset.profileGoodGreen.original
        case (.normal, .yellow):
            return ImageAsset.profileGoodYellow.original
        case (.stiffness, .black):
            return ImageAsset.profileHardBlack.original
        case (.stiffness, .brown):
            return ImageAsset.profileHardBrown.original
        case (.stiffness, .green):
            return ImageAsset.profileHardGreen.original
        case (.stiffness, .pink):
            return ImageAsset.profileHardRed.original
        case (.stiffness, .yellow):
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
}
