//
//  ConditionSelectionCell.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/20.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import CoreEntity
import DesignSystem

final class ConditionSelectionCell: UICollectionViewCell {
    
    private let conditionSelectionView: ConditionSelectionView = {
        let view = ConditionSelectionView()
        return view
    }()
    
    var isChecked: Bool = false {
        didSet {
            conditionSelectionView.isChecked = isChecked
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.addSubview(conditionSelectionView)
        
        conditionSelectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with condition: SelectableConfirmationCondition) {
        conditionSelectionView.configure(with: condition)
    }
}
