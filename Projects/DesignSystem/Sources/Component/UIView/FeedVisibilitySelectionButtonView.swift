//
//  FeedVisibilitySelectionButtonView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public final class FeedVisibilitySelectionButtonView: SelectableTextRadioButtonView {
    override public var imagePadding: SelectableTextRadioButtonView.ImagePadding {
        return .large
    }
    
    public override func toggleRadioButton(isSelected: Bool) {
        super.toggleRadioButton(isSelected: isSelected)
        changeDescriptionLabelTextColor(by: isSelected)
    }
    
    public override init(index: Int, title: String) {
        super.init(index: index, title: title)
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .bold)
        descriptionLabel.textColor = ColorAsset.gray800.color
    }
    
    private func changeDescriptionLabelTextColor(by isSelected: Bool) {
        descriptionLabel.textColor = isSelected ? .label : ColorAsset.gray800.color
    }
}
