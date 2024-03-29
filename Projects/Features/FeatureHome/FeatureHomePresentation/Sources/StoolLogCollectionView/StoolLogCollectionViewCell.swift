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

final class StoolLogCollectionViewCell: UICollectionViewCell {
    
    private let containerView = UIView()
    
    private let shadowView: ShadowView = {
        let shadowView = ShadowView()
        shadowView.layer.borderWidth = 1
        shadowView.layer.borderColor = ColorAsset.gray300.color.cgColor
        return shadowView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
        timeDescriptionLabel.text = nil
        stoolCharactorImageView.image = nil
        backgroundImageView.image = nil
    }
}

// MARK: - Supporting Methods

extension StoolLogCollectionViewCell {
    func configure(with stoolLogItem: StoolLogItem) {
        switch stoolLogItem.itemState {
        case .stoolLog(let stoolLogEntity):
            timeDescriptionLabel.text = stoolLogEntity.date.localizedTimeString
            stoolCharactorImageView.image = stoolLogEntity.stoolImage
            backgroundImageView.image = ImageAsset.logBackground.original
        case .empty:
            backgroundImageView.image = ImageAsset.logEmpty.original
        }
    }
}

// MARK: - UI Layout

private extension StoolLogCollectionViewCell {
    func layoutUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(shadowView)
        shadowView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(timeDescriptionLabel)
        backgroundImageView.addSubview(stoolCharactorImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
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
