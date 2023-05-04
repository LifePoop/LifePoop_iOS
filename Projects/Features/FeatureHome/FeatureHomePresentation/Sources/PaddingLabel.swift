//
//  PaddingLabel.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem // FIXME: DesignSystem 모듈로 이동할 경우 삭제

public class PaddingLabel: UILabel {
    
    private let padding: UIEdgeInsets
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    public init(padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
