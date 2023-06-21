//
//  FriendListCollectionViewCell.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem
import EntityUIMapper

public final class FriendListCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
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

public extension FriendListCollectionViewCell {
    func configure(with friendEntity: FriendEntity) {
        profileImageView.image = friendEntity.feedImage
        nameLabel.text = friendEntity.name
    }
}

// MARK: - UI Layout

private extension FriendListCollectionViewCell {
    func layoutUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(nameLabel.snp.top).offset(-6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }
}
