//
//  CircularImageView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit.UIImageView

public class CircularImageView: UIImageView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}
