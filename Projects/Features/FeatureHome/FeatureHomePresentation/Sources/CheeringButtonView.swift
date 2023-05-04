//
//  CheeringButtonView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class CheeringButtonView: ShadowView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(
            named: "TwoFriends",
            in: Bundle(identifier: "LifePoop.DesignSystem"), compatibleWith: nil
        )?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이길동님 외 12명이 응원하고 있어요!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구들 응원하러 가기"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var expandLeftImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(
            named: "ExpandLeft",
            in: Bundle(identifier: "LifePoop.DesignSystem"), compatibleWith: nil
        )?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        return stackView
    }()
    
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
    }
}

// MARK: - UI Layout

private extension CheeringButtonView {
    func layoutUI() {
        addSubview(imageView)
        addSubview(titleStackView)
        addSubview(expandLeftImageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(42)
            make.height.equalTo(24)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(4)
        }
        
        expandLeftImageView.snp.makeConstraints { make in
            make.centerY.equalTo(subtitleLabel)
            make.leading.equalTo(subtitleLabel.snp.trailing)
        }
    }
}
