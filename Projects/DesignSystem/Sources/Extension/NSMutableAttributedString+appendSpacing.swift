//
//  MSMutableAttributedString+appendSpacing.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/06/18.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    
    func appendSpacing(withPointOf point: CGFloat) {
        let padding = NSTextAttachment()
        padding.bounds = CGRect(x: .zero, y: .zero, width: point, height: 0)
        append(NSAttributedString(attachment: padding))
    }
}
