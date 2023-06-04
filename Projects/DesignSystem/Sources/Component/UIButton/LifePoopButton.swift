//
//  LifePoopButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class LifePoopButton: PaddingButton {
    
    private let title: String
    
    public override var isHighlighted: Bool {
        willSet {
            switch newValue {
            case true:
                backgroundColor = ColorAsset.disabledBlue.color
            case false:
                backgroundColor = ColorAsset.primary.color
            }
        }
    }
    
    public override var isEnabled: Bool {
        willSet {
            switch newValue {
            case true:
                backgroundColor = ColorAsset.primary.color
            case false:
                backgroundColor = ColorAsset.disabledBlue.color
            }
        }
    }
    
    public init(title: String) {
        self.title = title
        super.init(padding: Padding.custom(UIEdgeInsets(top: 17.5, left: .zero, bottom: 17.5, right: .zero)))
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = ColorAsset.primary.color
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.systemBackground,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
        )
        setAttributedTitle(attributedTitle, for: .normal)
        setTitleColor(.systemBackground, for: .normal)
        setTitleColor(.systemBackground, for: .disabled)
    }
}
