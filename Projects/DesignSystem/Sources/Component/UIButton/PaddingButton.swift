//
//  PaddingButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/02.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public class PaddingButton: UIButton {
    
    private let padding: UIEdgeInsets

    open override var intrinsicContentSize: CGSize {
        var contentSize: CGSize = titleLabel?.intrinsicContentSize ?? .zero
        if super.intrinsicContentSize == .zero {
            return contentSize
        }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }

    public init(padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
