//
//  ConditionSelectionView.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem

final class ConditionSelectionView: UIControl {

    private let selectedCheckBoxImage = ImageAsset.checkboxSelected.image
    private let deselectedCheckBoxImage = ImageAsset.checkboxDeselected.image
    
    private lazy var checkBoxImageView = UIImageView(image: deselectedCheckBoxImage)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼에 대한 설명"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorAsset.gray800.color
        label.sizeToFit()
        return label
    }()
    
    var isChecked: Bool = false {
        didSet {
            let image = isSelected ? selectedCheckBoxImage : deselectedCheckBoxImage
            checkBoxImageView.image = image
        }
    }

    let detailViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(ColorAsset.primary.color, for: .normal)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        let targetHeight = max(descriptionLabel.bounds.height, checkBoxImageView.bounds.height)
        
        return CGSize(width: bounds.width, height: targetHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let checkBoxFrame = checkBoxImageView.convert(checkBoxImageView.bounds, to: self)
        let detailViewButtonFrame = detailViewButton.convert(detailViewButton.bounds, to: self)
        
        let isCheckBoxTouched = checkBoxFrame.contains(point)
        let isDetailViewButtonTouched = detailViewButtonFrame.contains(point)
        
        switch (isCheckBoxTouched, isDetailViewButtonTouched) {
        case (true, _):
            return checkBoxImageView
        case (_, true):
            return detailViewButton
        default:
            return nil
        }
    }
    
    private func addSubViews() {
        
        addSubview(checkBoxImageView)
        addSubview(descriptionLabel)
        addSubview(detailViewButton)
                
        checkBoxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        detailViewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(checkBoxImageView.snp.centerY)
        }
    }
    
    func configure(with condition: SelectableConfirmationCondition) {
        
        descriptionLabel.text = condition.descriptionText
        detailViewButton.isHidden = !condition.containsDetailView
        
        switch condition.descriptionTextSize {
        case .normal:
            descriptionLabel.font = UIFont.systemFont(ofSize: condition.descriptionTextSize.value)
            descriptionLabel.textColor = ColorAsset.gray800.color
        case .large:
            descriptionLabel.font = UIFont.systemFont(ofSize: condition.descriptionTextSize.value, weight: .bold)
            descriptionLabel.textColor = ColorAsset.pooBlack.color
        }
    }
}
