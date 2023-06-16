//
//  InvitationCollectionViewCell.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

final class InvitationCollectionViewCell: UICollectionViewCell {
    
    private let iconImage = UIImageView(image: ImageAsset.invitationClip.original)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = ColorAsset.black.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with invitationType: InvitationType) {
        titleLabel.text = invitationType.description
    }
    
    private func addSubViews() {
        
        contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
