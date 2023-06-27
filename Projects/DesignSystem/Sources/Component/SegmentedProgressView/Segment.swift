//
//  Segment.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

final class Segment: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = 2.5
    }
    
    func setTracked() {
        backgroundColor = ColorAsset.white.color
    }
    
    func setUntracked() {
        backgroundColor = ColorAsset.primary.color
    }
}
