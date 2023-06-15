//
//  SatisfactionSelectViewController.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit

import DesignSystem
import Utils

public final class SatisfactionSelectViewController: LifePoopViewController, ViewType {
  
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.text = "잘 변했나요?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let satisfactionButton: UIButton = {
        let button = UIButton(type: .custom)
        let satisfactinoImage = ImageAsset.goodDeselected.image
        button.setImage(ImageAsset.goodDeselected.image, for: .normal)
        button.setImage(ImageAsset.goodSelected.image, for: .highlighted)
        button.setImage(ImageAsset.goodSelected.image, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let satisfactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.text = "네, 만족해요"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    private let disatisfactionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageAsset.badDeselected.image, for: .normal)
        button.setImage(ImageAsset.badSelected.image, for: .highlighted)
        button.setImage(ImageAsset.badSelected.image, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let disatisfactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.text = "아니요, 불만족해요"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    public var viewModel: SatisfactionSelectViewModel?
    private var disposeBag = DisposeBag()
    
    
    public func bindInput(to viewModel: SatisfactionSelectViewModel) {
        let input = viewModel.input
        
        satisfactionButton.rx.tap
            .bind(to: input.didTapSatisfactionButton)
            .disposed(by: disposeBag)
        
        disatisfactionButton.rx.tap
            .bind(to: input.didTapDisatisfactionButton)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SatisfactionSelectViewModel) {
        let output = viewModel.output
        
        output.satisfactionButtonSelected
            .asDriver()
            .drive(onNext: { [weak self] isSatisfactionSelected in
                guard let self = self else { return }
                self.satisfactionButton.rx.isSelected.onNext(isSatisfactionSelected)
            })
            .disposed(by: disposeBag)
        
        output.disatisfactionButtonSelected
            .asDriver()
            .drive(onNext: { [weak self] isDisatisfactionSelected in
                guard let self = self else { return }
                self.disatisfactionButton.rx.isSelected.onNext(isDisatisfactionSelected)
            })
            .disposed(by: disposeBag)        
    }
    
    public override func configureUI() {
        super.configureUI()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "잘 변했나요?"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
        view.addSubview(satisfactionButton)
        satisfactionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).inset(64)
            make.leading.equalToSuperview().offset(82)
            make.width.height.equalTo(62)
        }
        
        view.addSubview(disatisfactionButton)
        disatisfactionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).inset(64)
            make.trailing.equalToSuperview().inset(82)
            make.width.height.equalTo(62)
        }
        
        view.addSubview(satisfactionLabel)
        satisfactionLabel.snp.makeConstraints { make in
            make.top.equalTo(satisfactionButton.snp.bottom).offset(32)
            make.centerX.equalTo(satisfactionButton.snp.centerX)
        }
        
        view.addSubview(disatisfactionLabel)
        disatisfactionLabel.snp.makeConstraints { make in
            make.top.equalTo(disatisfactionButton.snp.bottom).offset(32)
            make.centerX.equalTo(disatisfactionButton.snp.centerX)
        }
    }
    
}
