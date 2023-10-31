//
//  CheeringButtonView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class CheeringButtonView: ShadowView {
    
    private let emptyCheeringFriendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.emptyThreeDots.original
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cheeringFriendProfileCharacterView = CheeringFriendProfileCharacterView()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = DesignSystemStrings.noCheeringYet
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = DesignSystemStrings.goToFriendList
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let expandRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.expandRight.original
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public let containerButton = UIButton()
    
    public override init() {
        super.init()
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension CheeringButtonView {
    func configureUI() {
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = ColorAsset.gray300.color.cgColor
    }
}

// MARK: - UI Layout

private extension CheeringButtonView {
    func layoutUI() {
        addSubview(emptyCheeringFriendImageView)
        addSubview(cheeringFriendProfileCharacterView)
        addSubview(titleStackView)
        addSubview(expandRightImageView)
        addSubview(containerButton)
        
        emptyCheeringFriendImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleStackView).offset(10.5)
        }
        
        cheeringFriendProfileCharacterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleStackView)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17.5)
            make.bottom.equalToSuperview().inset(20.5)
            make.leading.equalTo(emptyCheeringFriendImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        
        expandRightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(subtitleLabel)
            make.leading.equalTo(subtitleLabel.snp.trailing)
        }
        
        containerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Public Methods

public extension CheeringButtonView {
    func updateCheeringFriend(name: String, extraCount: Int) {
        if extraCount >= 1 {
            titleLabel.text = DesignSystemStrings.multipleFriendsAreCheeringYou(name, extraCount)
        } else {
            titleLabel.text = DesignSystemStrings.friendIsCheeringYou(name)
        }
    }
    
    func showCheeringFriendImage(firstImage: UIImage?, secondImage: UIImage? = nil) {
        emptyCheeringFriendImageView.isHidden = true
        cheeringFriendProfileCharacterView.isHidden = false
        cheeringFriendProfileCharacterView.setCheeringFriendProfileCharacter(
            firstImage: firstImage,
            secondImage: secondImage
        )
        
        titleStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(17.5)
            make.bottom.equalToSuperview().inset(20.5)
            make.leading.equalTo(cheeringFriendProfileCharacterView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func showEmptyCheeringFriendImage() {
        emptyCheeringFriendImageView.isHidden = false
        cheeringFriendProfileCharacterView.isHidden = true
        titleLabel.text = DesignSystemStrings.noCheeringYet
        
        titleStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(17.5)
            make.bottom.equalToSuperview().inset(20.5)
            make.leading.equalTo(emptyCheeringFriendImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
