//
//  ReportContainerView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/07.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

public final class ReportContainerView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var containerRoundedShadowView: ShadowView = {
        let view = ShadowView()
        view.layer.borderColor = ColorAsset.gray300.color.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let innerView: UIView
    private let paddingInsets: UIEdgeInsets
    
    public init(title: String, innerView: UIView, innerViewInsetPadding: Padding) {
        self.innerView = innerView
        self.paddingInsets = innerViewInsetPadding.insets
        super.init(frame: .zero)
        titleLabel.text = title
        layoutUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(titleLabel)
        addSubview(containerRoundedShadowView)
        containerRoundedShadowView.addSubview(innerView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
        }
        
        containerRoundedShadowView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        innerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(paddingInsets.top)
            make.bottom.equalToSuperview().inset(paddingInsets.bottom)
            make.leading.equalToSuperview().offset(paddingInsets.left)
            make.trailing.equalToSuperview().inset(paddingInsets.right)
        }
    }
}
