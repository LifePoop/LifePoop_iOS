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

public final class SatisfactionSelectViewController: UIViewController, ViewType {
  
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
        return button
    }()
    
    private let satisfactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.text = "네, 만족해요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    private let disatisfactionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageAsset.badDeselected.image, for: .normal)
        button.setImage(ImageAsset.badSelected.image, for: .highlighted)
        return button
    }()
    
    private let disatisfactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.text = "아니요, 불만족해요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    public var viewModel: SatisfactionSelectViewModel?
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
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
                
                let image = isSatisfactionSelected ?
                    ImageAsset.goodSelected.image :
                    ImageAsset.goodDeselected.image
                self.satisfactionButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.disatisfactionButtonSelected
            .asDriver()
            .drive(onNext: { [weak self] isDisatisfactionSelected in
                guard let self = self else { return }
                
                let image = isDisatisfactionSelected ?
                    ImageAsset.badSelected.image :
                    ImageAsset.badDeselected.image
                self.disatisfactionButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)        
    }
}

private extension SatisfactionSelectViewController {
    
    func configureUI() {
        setAttributes()
        addSubViews()
    }
    
    func addSubViews() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        view.addSubview(satisfactionButton)
        satisfactionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(82)
        }
        
        view.addSubview(disatisfactionButton)
        disatisfactionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(82)
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
    
    func setAttributes() {
        view.backgroundColor = ColorAsset.white.color
    }
}
