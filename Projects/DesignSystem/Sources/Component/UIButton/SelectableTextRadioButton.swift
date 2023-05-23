//
//  SelectableTextRadioButton.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class SelectableTextRadioButton: UIButton {
    
    public let index: Int
    private let title: String
    private let selectedImage = ImageAsset.btnRadioSelected.original
    private let deselectedImage = ImageAsset.btnRadioDeselected.original
    
    public init(index: Int, title: String) {
        self.index = index
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = deselectedImage
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 12)
        
        var attributedTitleText = AttributedString(stringLiteral: title)
        attributedTitleText.font = UIFont.systemFont(ofSize: 14)
        attributedTitleText.foregroundColor = .label
        configuration.attributedTitle = attributedTitleText
        
        self.configuration = configuration
    }
    
    public func toggleRadioButton(isSelected: Bool) {
        configuration?.image = isSelected ? selectedImage : deselectedImage
    }
}
