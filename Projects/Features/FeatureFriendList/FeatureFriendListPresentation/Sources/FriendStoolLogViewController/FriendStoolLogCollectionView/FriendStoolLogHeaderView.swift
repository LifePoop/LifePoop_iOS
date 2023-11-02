//
//  FriendStoolLogHeaderView.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/11/02.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import DesignSystemReactive
import EntityUIMapper
import Utils

final class FriendStoolLogHeaderView: UICollectionReusableView {
    
    private let friendStoolLogTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let friendStoolLogEmptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cheeringInfoView: CheeringFriendProfileCharacterView = {
        let view = CheeringFriendProfileCharacterView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    private let cheeringCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var cheeringInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cheeringInfoView, cheeringCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with viewModel: FriendStoolLogHeaderViewModel) {
        set(friendName: viewModel.friendNickname)
        
        if viewModel.isStoolLogEmpty {
            showEmptyCheeringView(with: viewModel.friendNickname)
            return
        }
        
        if viewModel.cheeringFriendCount > .zero {
            showCheeringInfoView(
                cheeringCount: viewModel.cheeringFriendCount,
                firstImage: viewModel.firstCheeringCharacter?.cheeringImage,
                secondImage: viewModel.secondCheeringCharacter?.cheeringImage
            )
        }
    }
    
    private func set(friendName: String) {
        friendStoolLogTitleLabel.text = LocalizableString.stoolDiaryForFriend(friendName)
    }
    
    private func showEmptyCheeringView(with friendName: String) {
        friendStoolLogEmptyDescriptionLabel.text = LocalizableString.friendStoolDiaryEmpty(friendName)
        cheeringInfoStackView.isHidden = true
        
        friendStoolLogTitleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(friendStoolLogEmptyDescriptionLabel.snp.top)
            make.leading.trailing.equalToSuperview().offset(24)
        }
    }
    
    private func showCheeringInfoView(cheeringCount: Int, firstImage: UIImage?, secondImage: UIImage?) {
        friendStoolLogEmptyDescriptionLabel.isHidden = true
        cheeringInfoView.setCheeringFriendProfileCharacter(firstImage: firstImage, secondImage: secondImage)
        cheeringCountLabel.text = LocalizableString.cheeringCount(cheeringCount)
        
        friendStoolLogTitleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(cheeringInfoStackView.snp.top).offset(-11)
            make.leading.trailing.equalToSuperview().offset(24)
        }
    }
}

// MARK: - UI Layout

private extension FriendStoolLogHeaderView {
    func layoutUI() {
        addSubview(friendStoolLogTitleLabel)
        addSubview(friendStoolLogEmptyDescriptionLabel)
        addSubview(cheeringInfoStackView)
        
        friendStoolLogTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(24)
        }
        
        friendStoolLogEmptyDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(friendStoolLogTitleLabel)
            make.bottom.equalToSuperview()
        }
        
        cheeringInfoStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(friendStoolLogTitleLabel)
            make.bottom.equalToSuperview()
        }
    }
}
