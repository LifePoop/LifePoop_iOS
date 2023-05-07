//
//  SizeSelectionCell.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit
import CoreEntity
import DesignSystem


final class SizeSelectionCell: UICollectionViewCell {
        
    private let imageView: UIImageView = UIImageView(image: ImageAsset.sizeSelectMedium.original)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(sizeSelection: SelectableSize) {
        
        var image: UIImage
        switch sizeSelection {
        case .small:
            image = ImageAsset.sizeSelectSmall.image
        case .medium:
            image = ImageAsset.sizeSelectMedium.image
        case .large:
            image = ImageAsset.sizeSelectLarge.image
        }
        imageView.image = image
    }
    
    private func addSubViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
