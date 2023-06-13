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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(storyButton)
        storyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with friend: FriendEntity) {
        
        nicknameLabel.text = friend.name
        profileImageView.image = getProfileImage(with: friend.profile)
    }
    
    private func getProfileImage(with profile: ProfileCharacter) -> UIImage {
        
        switch (profile.color, profile.shape) {
        case (StoolColor.yellow, StoolShape.soft):
            return ImageAsset.profileSoftYellow.original
        case (StoolColor.pink, StoolShape.soft):
            return ImageAsset.profileSoftRed.original
        case (StoolColor.black, StoolShape.soft):
            return ImageAsset.profileSoftBlack.original
        case (StoolColor.brown, StoolShape.soft):
            return ImageAsset.profileSoftBrown.original
        case (StoolColor.green, StoolShape.soft):
            return ImageAsset.profileSoftGreen.original
        case (StoolColor.yellow, StoolShape.hard):
            return ImageAsset.profileHardYellow.original
        case (StoolColor.pink, StoolShape.hard):
            return ImageAsset.profileHardRed.original
        case (StoolColor.black, StoolShape.hard):
            return ImageAsset.profileHardBlack.original
        case (StoolColor.brown, StoolShape.hard):
            return ImageAsset.profileHardBrown.original
        case (StoolColor.green, StoolShape.hard):
            return ImageAsset.profileHardGreen.original
        case (StoolColor.yellow, StoolShape.good):
            return ImageAsset.profileGoodYellow.original
        case (StoolColor.pink, StoolShape.good):
            return ImageAsset.profileGoodRed.original
        case (StoolColor.black, StoolShape.good):
            return ImageAsset.profileGoodBlack.original
        case (StoolColor.brown, StoolShape.good):
            return ImageAsset.profileGoodBrown.original
        case (StoolColor.green, StoolShape.good):
            return ImageAsset.profileGoodGreen.original
        }
    }
}
