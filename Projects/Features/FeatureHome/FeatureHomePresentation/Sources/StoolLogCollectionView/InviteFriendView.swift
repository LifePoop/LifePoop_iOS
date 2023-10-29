//
//  InviteFriendView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/06/22.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

import Utils

final class InviteFriendView: UIView {
    
    private let myProfileCharactorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.profileGoodGray.original
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.me
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myProfileCharactorImageView, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.inviteFriendsAndEncourageBowelMovements
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = ColorAsset.gray800.color
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let expandRightImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.expandRightLarge.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        addSubview(profileStackView)
        addSubview(descriptionLabel)
        addSubview(expandRightImageView)
        
        profileStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(myProfileCharactorImageView.snp.trailing).offset(26)
            make.trailing.equalTo(expandRightImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        expandRightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(31)
            make.centerY.equalToSuperview()
        }
    }
}

extension InviteFriendView {
    @available(*, deprecated, message: "사용자 프로필 캐릭터가 아닌 기본 이미지(profileGoodGray)를 나타내도록 변경되어 더 이상 사용하지 않음")
    func setMyProfileCharactor(image: UIImage, name: String) {
        myProfileCharactorImageView.image = image
        nameLabel.text = name
    }
}
