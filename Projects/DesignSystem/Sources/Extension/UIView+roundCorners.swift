//
//  UIView+roundCorners.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public enum RectCorner {
    
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var value: CACornerMask {
        switch self {
        case .topLeft:
            return .layerMinXMinYCorner
        case .topRight:
            return .layerMaxXMinYCorner
        case .bottomLeft:
            return .layerMinXMaxYCorner
        case .bottomRight:
            return .layerMaxXMaxYCorner
        }
    }

}

extension UIView {
    
    public func roundCorners(
        corners: [RectCorner] = [.topLeft, .topRight, .bottomLeft, .bottomRight],
        radius: CGFloat) {
            
        clipsToBounds = true
        layer.cornerRadius = radius
        let maskedCorners = corners.map { $0.value }
        layer.maskedCorners = CACornerMask(maskedCorners)
    }
}
