//
//  StoolLogCollectionViewCell.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem

public final class StoolLogCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = ShadowView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = DesignSystemAsset.Image
            .stoolLogBackgroundTile.image
            .withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

public extension StoolLogCollectionViewCell {
    func configure(with stoolLogEntity: StoolLogEntity) {
        
    }
}

// MARK: - UI Layout

private extension StoolLogCollectionViewCell {
    func layoutUI() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
