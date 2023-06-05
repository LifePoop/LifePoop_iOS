//
//  RoundedPaddingLabel.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public class RoundedPaddingLabel: PaddingLabel {
    public override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}
