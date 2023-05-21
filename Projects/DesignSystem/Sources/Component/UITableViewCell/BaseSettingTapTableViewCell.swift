//
//  BaseSettingTapTableViewCell.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

open class BaseSettingTapTableViewCell: BaseSettingTableViewCell {
    
    public lazy var expandImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.expandRight.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
    override open func configureSelectionStyle() {
        super.configureSelectionStyle()
        addGestureRecognizer(tapGesture)
    }
    
    override open func layoutUI() {
        super.layoutUI()
        contentView.addSubview(expandImageView)
        
        expandImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-37)
        }
    }
}
