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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAsset.cheeringFriends.original
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = DesignSystemStrings.goCheeringFriends
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
    
    public func configureLabel(text: String) {
        titleLabel.text = text
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
        addSubview(imageView)
        addSubview(titleStackView)
        addSubview(expandRightImageView)
        addSubview(containerButton)
        
        snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(42)
            make.height.equalTo(24)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(12)
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
