//
//  NoFriendStoolLogYetView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import DesignSystem
import SnapKit

import Utils

final class NoFriendStoolLogYetView: UIView {
    
    private let emptyProfileCharactorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.profileGoodGray.original
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.noFriendStoolLogYet
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = ColorAsset.gray800.color
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func layoutUI() {
        addSubview(emptyProfileCharactorImageView)
        addSubview(descriptionLabel)
        
        emptyProfileCharactorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(emptyProfileCharactorImageView.snp.trailing).offset(26)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
