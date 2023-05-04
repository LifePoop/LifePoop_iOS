//
//  SeparatorView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class SeparatorView: UIView {
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: 1.0)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray6
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
