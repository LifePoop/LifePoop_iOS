//
//  LoginButton.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class LoginButton: UIButton {
    
    private let title: String
    private let iconImage: UIImage?
    private let fontColor: UIColor
    private let baseBackgroundColor: UIColor
        
    public init(title: String, backgroundColor: UIColor, fontColor: UIColor, iconImage: UIImage? = nil) {
        self.title = title
        self.iconImage = iconImage
        self.baseBackgroundColor = backgroundColor
        self.fontColor = fontColor
        
        super.init(frame: .zero)

        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        var config = UIButton.Configuration.filled()
        config.image = iconImage
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.contentInsets = .init(top: 17.5, leading: 17.5, bottom: 17.5, trailing: 17.5)
        
        var attributedTitleText = AttributedString(title)
        attributedTitleText.font = .systemFont(ofSize: 16, weight: .bold)
        config.attributedTitle = attributedTitleText

        config.baseBackgroundColor = baseBackgroundColor
        config.baseForegroundColor = fontColor
        config.background.cornerRadius = 12
                
        configuration = config
    }
}

// MARK: Loading Indicator

public extension LoginButton {
    func showLoadingIndicator() {
        isEnabled = false
        configuration?.showsActivityIndicator = true
    }
    
    func hideLoadingIndicator() {
        isEnabled = true
        configuration?.showsActivityIndicator = false
    }
}
