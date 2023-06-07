//
//  ColorSelectionCell.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem
import Utils

final class ColorSelectionCell: UICollectionViewCell {
    
    private let imageView: UIImageView = UIImageView(image: ImageAsset.colorBlackDeselected.original)

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
    
    private func addSubViews() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(selectableColor: StoolColor) {
        
        switch selectableColor {
        case .black:
            selectedImage = ImageAsset.colorBlackSelected.original
            deselectedImage = ImageAsset.colorBlackDeselected.original
        case .brown:
            selectedImage = ImageAsset.colorBrownSelected.original
            deselectedImage = ImageAsset.colorBrownDeselected.original
        case .green:
            selectedImage = ImageAsset.colorGreenSelected.original
            deselectedImage = ImageAsset.colorGreenDeselected.original
        case .pink:
            selectedImage = ImageAsset.colorPinkSelected.original
            deselectedImage = ImageAsset.colorPinkDeselected.original
        case .yellow:
            selectedImage = ImageAsset.colorYellowSelected.original
            deselectedImage = ImageAsset.colorYellowDeselected.original
        }
        
        imageView.image = deselectedImage
    }
}
