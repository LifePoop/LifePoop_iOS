//
//  FriendListCollectionViewCell.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem
import EntityUIMapper
import Utils

final class FriendListCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.profileGoodYellow.original
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = ColorAsset.black.color
        return label
    }()
    
    private let storyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageAsset.expandRight.original, for: .normal)
        return button
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
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(storyButton)
        storyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(29)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with friend: FriendEntity) {
        nicknameLabel.text = friend.name
        profileImageView.image = friend.profile.image
    }
}
