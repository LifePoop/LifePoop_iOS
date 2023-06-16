//
//  ShapeSelectionCell.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem

final class ShapeSelectionCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var selectedImage: UIImage?
    private var deselectedImage: UIImage?
    
    private var updatedSelectedImage: (() -> Void)?
    
    override var isSelected: Bool {
        didSet {
            updatedSelectedImage?()
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isImageViewTouched = imageView.point(inside: point, with: event)
        return isImageViewTouched
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updatedSelectedImage = nil
    }
    
    func configure(stoolShapeSelection: StoolShape, colorOf color: StoolColor = .brown) {

        updatedSelectedImage = { [weak self] in
            guard let self = self else { return }
            
            switch stoolShapeSelection {
            case .soft:
                self.selectedImage = self.getSelectedSoftImage(for: color)
                self.deselectedImage = ImageAsset.shapeSoftDeselected.original
            case .good:
                self.selectedImage = self.getSelectedGoodImage(for: color)
                self.deselectedImage = ImageAsset.shapeGoodDeselected.original
            case .hard:
                self.selectedImage = self.getSelectedHardImage(for: color)
                self.deselectedImage = ImageAsset.shapeHardDeselected.original
            }
            
            self.imageView.image = self.isSelected ? self.selectedImage : self.deselectedImage
        }
        
        updatedSelectedImage?()
    }
    
    private func addSubViews() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

private extension ShapeSelectionCell {
    
    func getSelectedSoftImage(for color: StoolColor) -> UIImage {
       switch color {
       case .brown:
           return ImageAsset.shapeSoftSelectedBrown.original
       case .black:
           return ImageAsset.shapeSoftSelectedBlack.original
       case .pink:
           return ImageAsset.shapeSoftSelectedPink.original
       case .green:
           return ImageAsset.shapeSoftSelectedGreen.original
       case .yellow:
           return ImageAsset.shapeSoftSelectedYellow.original
       }
   }
    
    func getSelectedGoodImage(for color: StoolColor) -> UIImage {
       switch color {
       case .brown:
           return ImageAsset.shapeGoodSelectedBrown.original
       case .black:
           return ImageAsset.shapeGoodSelectedBlack.original
       case .pink:
           return ImageAsset.shapeGoodSelectedPink.original
       case .green:
           return ImageAsset.shapeGoodSelectedGreen.original
       case .yellow:
           return ImageAsset.shapeGoodSelectedYellow.original
       }
   }

    func getSelectedHardImage(for color: StoolColor) -> UIImage {
       switch color {
       case .brown:
           return ImageAsset.shapeHardSelectedBrown.original
       case .black:
           return ImageAsset.shapeHardSelectedBlack.original
       case .pink:
           return ImageAsset.shapeHardSelectedPink.original
       case .green:
           return ImageAsset.shapeHardSelectedGreen.original
       case .yellow:
           return ImageAsset.shapeHardSelectedYellow.original
       }
   }

}
