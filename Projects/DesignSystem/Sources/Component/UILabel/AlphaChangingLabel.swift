//
//  AlphaChangingLabel.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/10/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public class AlphaChangingFooterLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        textColor = ColorAsset.gray800.color
        textAlignment = .center
        alpha = .zero
        font = UIFont.systemFont(ofSize: 16)
    }
}

public extension AlphaChangingFooterLabel {
    /// contentOffsetY, contentHeight, frameHeight에 따라 Label의 alpha 값을 변경합니다
    func adjustAlphaBasedOnOffset(
        _ offsetY: CGFloat,
        contentHeight: CGFloat,
        frameHeight: CGFloat
    ) {
        guard offsetY > .zero else {
            alpha = .zero
            return
        }
        
        let adjustmentValue = ((offsetY - (contentHeight - frameHeight + 135)) / 100) * 2.25
        if (offsetY > contentHeight - frameHeight) && offsetY != .zero {
            alpha = adjustmentValue
        }
    }
}
