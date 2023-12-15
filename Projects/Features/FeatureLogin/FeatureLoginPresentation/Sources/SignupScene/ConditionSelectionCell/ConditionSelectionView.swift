//
//  ConditionSelectionView.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem

final class ConditionSelectionView: UIControl {

    private let selectedCheckBoxImage = ImageAsset.checkboxSelected.image
    private let deselectedCheckBoxImage = ImageAsset.checkboxDeselected.image
    
    private lazy var checkBoxImageView: UIImageView = {
        let imageView = UIImageView(image: deselectedCheckBoxImage)
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)

        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorAsset.gray800.color
        label.sizeToFit()
        return label
    }()
    
    private let essentialMark: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ColorAsset.primary.color
        label.text = "*"
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    
    var isChecked: Bool = false {
        didSet {
            let image = isChecked ? selectedCheckBoxImage : deselectedCheckBoxImage
            checkBoxImageView.image = image
        }
    }
    
    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    public var markAsEssential: Bool = false {
        didSet {
            essentialMark.isHidden = !markAsEssential
        }
    }

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
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        sendActions(for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    private func addSubViews() {
        
        addSubview(checkBoxImageView)
        addSubview(descriptionLabel)
        addSubview(essentialMark)
                
        checkBoxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        essentialMark.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.top)
            make.leading.equalTo(descriptionLabel.snp.trailing)
        }
    }
    
    func configure(with condition: AgreementCondition) {
        
        descriptionLabel.text = condition.descriptionText
        
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
