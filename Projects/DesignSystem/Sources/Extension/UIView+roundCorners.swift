//
//  UIView+roundCorners.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

extension UIView {
    
    public func roundCorners(_ radius: CGFloat = 10) {
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
