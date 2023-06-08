//
//  GenderSelectionCell.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem

final class GenderSelectionCell: UICollectionViewCell {
    
    private let genderSelectButton: LifePoopButton = {
        let button = LifePoopButton(title: "")
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with gender: String) {
        genderSelectButton.title = gender
    }
    
    private func addSubViews() {
        
        contentView.addSubview(genderSelectButton)
        
        genderSelectButton.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
