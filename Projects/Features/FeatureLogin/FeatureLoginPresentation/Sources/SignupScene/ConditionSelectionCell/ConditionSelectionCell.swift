//
//  ConditionSelectionCell.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/20.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

import CoreEntity
import DesignSystem

final class ConditionSelectionCell: UICollectionViewCell {
    
    let conditionSelectionView: ConditionSelectionView = {
        let view = ConditionSelectionView()
        return view
    }()
    
    let detailViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(ColorAsset.primary.color, for: .normal)
        return button
    }()
    
    var isChecked: Bool = false {
        didSet {
            conditionSelectionView.isChecked = isChecked
        }
    }
    
    private (set)var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    private func addSubViews() {
        contentView.addSubview(conditionSelectionView)
        contentView.addSubview(detailViewButton)

        conditionSelectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        detailViewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func bind(to viewModel: ConditionSelectionCellViewModel, withIndexOf index: Int) {
        disposeBag = DisposeBag()
        
        viewModel.output.shouldHideDetailViewButton
            .bind(to: detailViewButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldSelectCheckBox
            .bind(to: conditionSelectionView.rx.isChecked)
            .disposed(by: disposeBag)
        
        viewModel.output.conditionDescription
            .bind(to: conditionSelectionView.rx.descriptionText)
            .disposed(by: disposeBag)
        
        detailViewButton.rx.tap
            .map { index }
            .bind(to: viewModel.input.didTapDetailButton)
            .disposed(by: disposeBag)
        
        conditionSelectionView.rx.check
            .bind(to: viewModel.input.didTapCheckBox)
            .disposed(by: disposeBag)
    }
}
