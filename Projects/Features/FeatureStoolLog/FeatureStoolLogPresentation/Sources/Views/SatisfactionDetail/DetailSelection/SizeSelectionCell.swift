//
//  SizeSelectionCell.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import CoreEntity
import SnapKit
import DesignSystem


final class SizeSelectionCell: UICollectionViewCell {
        
    private let imageView: UIImageView = UIImageView(image: ImageAsset.sizeSelectMediumDeselected.original)
    
    private var selectedImage: UIImage?

    private var deselectedImage: UIImage?

    override var isSelected: Bool {
        didSet {
            imageView.image = isSelected ? selectedImage : deselectedImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(selectableSize: SelectableSize) {
        
        switch selectableSize {
        case .small:
            selectedImage = ImageAsset.sizeSelectSmallSelected.image
            deselectedImage = ImageAsset.sizeSelectSmallDeselected.image
        case .medium:
            selectedImage = ImageAsset.sizeSelectMediumSelected.image
            deselectedImage = ImageAsset.sizeSelectMediumDeselected.image
        case .large:
            selectedImage = ImageAsset.sizeSelectLargeSelected.image
            deselectedImage = ImageAsset.sizeSelectLargeDeselected.image
        }
        
        imageView.image = deselectedImage
    }
    
    private func addSubViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
