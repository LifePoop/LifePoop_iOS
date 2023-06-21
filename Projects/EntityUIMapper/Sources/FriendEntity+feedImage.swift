//
//  FriendEntity+feedImage.swift
//  EntityUIMapper
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

public extension FriendEntity {
    var feedImage: UIImage {
        return isActivated ? profile.highlightedImage : profile.image
    }
}
