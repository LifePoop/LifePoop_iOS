//
//  BaseSettingTextTapTableViewCell.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

open class BaseSettingTextTapTableViewCell: BaseSettingTapTableViewCell {
    
    public lazy var addtionalTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override open func layoutUI() {
        super.layoutUI()
        contentView.addSubview(addtionalTextLabel)
        
        addtionalTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(expandImageView.snp.leading).offset(-4)
        }
    }
}
