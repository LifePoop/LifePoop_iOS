//
//  TextSelectionButton.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//
import UIKit

public final class TextSelectionButton: UIButton {
    
    public struct BackgroundColor {
        let selected: UIColor
        let deselected: UIColor
        
        public init(selected: UIColor, deselected: UIColor) {
            self.selected = selected
            self.deselected = deselected
        }
    }
    
    public struct TextColor {
        let selected: UIColor
        let deselected: UIColor
        
        public init(selected: UIColor, deselected: UIColor) {
            self.selected = selected
            self.deselected = deselected
        }
    }
    
    public let index: Int
    private let title: String
    private let mutableBackgroundColor: BackgroundColor
    private let mutableTitleColor: TextColor
    
    public init(
        index: Int,
        title: String,
        backgroundColor: BackgroundColor,
        titleColor: TextColor
    ) {
        self.index = index
        self.title = title
        self.mutableBackgroundColor = backgroundColor
        self.mutableTitleColor = titleColor
        super.init(frame: .zero)
        
        configure()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {        
        setTitle(title, for: .normal)
        
        setTitleColor(mutableTitleColor.selected, for: .selected)
        setTitleColor(mutableTitleColor.selected, for: .highlighted)
        setTitleColor(mutableTitleColor.deselected, for: .normal)
        setTitleColor(mutableTitleColor.deselected, for: .disabled)

        setBackgroundColor(mutableBackgroundColor.selected, for: .selected)
        setBackgroundColor(mutableBackgroundColor.selected, for: .highlighted)
        setBackgroundColor(mutableBackgroundColor.deselected, for: .normal)
        setBackgroundColor(mutableBackgroundColor.deselected, for: .disabled)

        clipsToBounds = true
        layer.cornerRadius = 8
    }
}

public extension TextSelectionButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
