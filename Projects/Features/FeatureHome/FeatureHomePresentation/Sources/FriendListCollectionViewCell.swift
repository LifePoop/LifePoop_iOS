//
//  FriendListCollectionViewCell.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class FriendListCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView = ProfileImageView()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}

public extension FriendListCollectionViewCell {
    func configure(with friendEntity: FriendEntity) {
        profileImageView.setImage(by: friendEntity.isActivated)
        nameLabel.text = friendEntity.name
    }
}

// MARK: - UI Layout

private extension FriendListCollectionViewCell {
    func layoutUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(profileImageView.snp.width)
            make.bottom.equalTo(nameLabel.snp.top).offset(-6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalTo(contentView)
        }
    }
}
