//
//  BannerImageCell.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/16.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem

final class BannerImageCell: UICollectionViewCell {
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.characterLarge.image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        
        contentView.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints { make in
            make.height.equalTo(225)
            make.width.equalTo(153)
            make.center.equalToSuperview()
        }
    }
    
    func configure(imageData: Data) {
        bannerImageView.image = UIImage(data: imageData)
    }
}
