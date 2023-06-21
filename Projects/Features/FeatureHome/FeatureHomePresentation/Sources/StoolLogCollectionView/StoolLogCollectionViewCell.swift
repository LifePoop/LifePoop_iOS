//
//  StoolLogCollectionViewCell.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem
import EntityUIMapper

public final class StoolLogCollectionViewCell: UICollectionViewCell {
    
    private let containerView = ShadowView()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.logBackground.original)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let timeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = ColorAsset.gray800.color
        return label
    }()
    
    private let stoolCharactorImageView: UIImageView = {
        let imageView = UIImageView()
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
}

public extension StoolLogCollectionViewCell {
    func configure(with stoolLogEntity: StoolLogEntity) {
        timeDescriptionLabel.text = stoolLogEntity.date
        stoolCharactorImageView.image = stoolLogEntity.stoolImage
    }
}

// MARK: - UI Layout

private extension StoolLogCollectionViewCell {
    func layoutUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(timeDescriptionLabel)
        backgroundImageView.addSubview(stoolCharactorImageView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        timeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().inset(26)
        }
        
        stoolCharactorImageView.snp.makeConstraints { make in
            make.width.equalTo(backgroundImageView).multipliedBy(0.7)
            make.height.equalTo(backgroundImageView).multipliedBy(0.27)
            make.centerX.equalToSuperview().multipliedBy(0.9)
            make.centerY.equalToSuperview().multipliedBy(1.14)
        }
    }
}
