//
//  LifePoopButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class LifePoopButton: UIButton {
    
    private let title: String
    
    public override var isHighlighted: Bool {
        didSet {
            switch oldValue {
            case true:
                configuration?.baseBackgroundColor = ColorAsset.primary.color
            case false:
                configuration?.baseBackgroundColor = ColorAsset.disabledBlue.color
            }
        }
    }
    
    public init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.contentInsets = .init(top: 17.5, leading: 17.5, bottom: 17.5, trailing: 17.5)
        config.baseBackgroundColor = ColorAsset.primary.color
        
        var attributedTitleText = AttributedString(title)
        attributedTitleText.font = .systemFont(ofSize: 16, weight: .bold)
        config.attributedTitle = attributedTitleText
        
        configuration = config
    }
}
