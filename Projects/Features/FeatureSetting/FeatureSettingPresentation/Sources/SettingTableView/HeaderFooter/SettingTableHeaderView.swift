//
//  SettingTableHeaderView.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem

public final class SettingTableHeaderView: UITableViewHeaderFooterView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = ColorAsset.gray600.color
        return label
    }()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(_ text: String) {
        titleLabel.text = text
    }
}

// MARK: - UI Configuration

private extension SettingTableHeaderView {
    func layoutUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-37)
            make.top.bottom.equalToSuperview()
        }
    }
}
