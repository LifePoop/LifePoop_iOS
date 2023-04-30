//
//  Padding.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit.UIGeometry

public enum Padding {
    case small
    case medium
    case large
    
    public var insets: UIEdgeInsets {
        switch self {
        case .small:
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        case .medium:
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        case .large:
            return UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        }
    }
}
