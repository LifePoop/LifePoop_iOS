//
//  UITextField+insertLeftPadding.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

extension UITextField {
    
    public func insertLeftPadding(of padding: CGFloat) {
      let spacer = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
      self.leftView = spacer
      self.leftViewMode = ViewMode.always
    }
}
