//
//  ShadowView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public class ShadowView: UIView {
    
    public init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}

// MARK: - UI Configuration

private extension ShadowView {
    func configureUI() {
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 16
        layer.masksToBounds = false
        backgroundColor = .systemBackground
    }
}
