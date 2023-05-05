//
//  DesignSystemImages+original.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

extension DesignSystemImages {
    public var original: UIImage {
        return image.withRenderingMode(.alwaysOriginal)
    }
}
