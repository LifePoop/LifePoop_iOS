//
//  UILabel+attributedString.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /// AttributedText에 설정된 AttributedString의 NSMutableAttributedString을 반환합니다.
    /// AttributedText가 설정되어있지 않으면, text로부터 NSMutableAttributedString을 생성하여 반환합니다.
    var mutableAttributedString: NSMutableAttributedString? {
        guard let labelText = text, let labelFont = font else { return nil }
        
        var attributedString: NSMutableAttributedString?
        
        if let attributedText = attributedText {
            attributedString = attributedText.mutableCopy() as? NSMutableAttributedString
        } else {
            attributedString = NSMutableAttributedString(
                string: labelText,
                attributes: [NSAttributedString.Key.font: labelFont]
            )
        }
        
        return attributedString
    }
    
    func rangeOfString(target searchString: String) -> NSRange? {
        guard let labelText = text,
              let targetRange = labelText.range(of: searchString) else {
            return nil
        }
        return NSRange(targetRange, in: labelText)
    }
    
    func applyFont(_ font: UIFont, range: NSRange?) {
        guard let attributedString = mutableAttributedString,
              let range = range else { return }
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedText = attributedString
    }
    
    func applyTextColor(_ color: UIColor, range: NSRange?) {
        guard let attributedString = mutableAttributedString,
              let range = range else { return }
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    func applyFontAndColor(font: UIFont, color: UIColor, range: NSRange?) {
        guard let range = range else { return }
        applyFont(font, range: range)
        applyTextColor(color, range: range)
    }
    
    func applyUnderline(range: NSRange?) {
        guard let attributedString = mutableAttributedString,
              let range = range else { return }
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range
        )
        attributedText = attributedString
    }
}
