//
//  SuggestionButton.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/24.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class SuggestionButton: PaddingButton {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "선택하기"
        label.textColor = ColorAsset.gray800.color
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let expandIconImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.expandDown.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public init() {
        super.init(padding: Padding.custom(UIEdgeInsets(top: 16.5, left: 12, bottom: 16.5, right: 12)))
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = ColorAsset.gray200.color
        layer.cornerRadius = 12
    }
    
    private func layoutUI() {
        addSubview(label)
        addSubview(expandIconImageView)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        expandIconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
