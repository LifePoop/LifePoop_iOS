//
//  String+nsAttributedString.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/07/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public extension String {
    func nsAttributedString(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: fontSize, weight: weight)
        ])
    }
}
