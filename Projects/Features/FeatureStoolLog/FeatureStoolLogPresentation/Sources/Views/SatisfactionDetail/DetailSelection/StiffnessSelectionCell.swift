//
//  StiffnessSelectionCell.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem

final class StiffnessSelectionCell: UICollectionViewCell {
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let imageView: UIImageView = UIImageView(image: ImageAsset.smileySadDeselected.original)
    
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
    
    func configure(stiffnessSelection: SelectableStiffness) {
        
        titlelabel.text = stiffnessSelection.description
        
        switch stiffnessSelection {
        case .soft:
            selectedImage = ImageAsset.smileyDeadSelected.image
            deselectedImage = ImageAsset.smileyDeadDeselected.image
        case .normal:
            selectedImage = ImageAsset.smileyHappySelected.image
            deselectedImage = ImageAsset.smileyHappyDeselected.image
        case .stiffness:
            selectedImage = ImageAsset.smileySadSelected.image
            deselectedImage = ImageAsset.smileySadDeselected.image
        }
        imageView.image = deselectedImage
    }
    
    private func addSubViews() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
