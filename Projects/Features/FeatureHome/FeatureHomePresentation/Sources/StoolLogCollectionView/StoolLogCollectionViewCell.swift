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

public final class StoolLogCollectionViewCell: UICollectionViewCell {
    
    private lazy var backgroundContainerView: UIView = {
        let view = ShadowView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.logBackground.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 11:58"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = ColorAsset.gray800.color
        return label
    }()
    
    private lazy var stoolCharactorImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSoftYellow.original)
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
        
    }
}

// MARK: - UI Layout

private extension StoolLogCollectionViewCell {
    func layoutUI() {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(dateLabel)
        backgroundImageView.addSubview(stoolCharactorImageView)
        
        backgroundContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }
        
        stoolCharactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
