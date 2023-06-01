//
//  ProfileEditViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import Utils

public final class ProfileEditViewController: LifePoopViewController, ViewType {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캐릭터를 설정해주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // TODO: Selection View 구현 - FeatureSatisfaction과 중복되는 컴포넌트 Design System으로 분리
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "색깔"
        return label
    }()
    
    private let shapeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "모양"
        return label
    }()
    
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [colorTitleLabel, shapeTitleLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private lazy var confirmButton: LifePoopButton = {
        let button = LifePoopButton(title: "설정 완료")
        button.isEnabled = false
        return button
    }()
    
    public var viewModel: ProfileEditViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ProfileEditViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: ProfileEditViewModel) {
        let output = viewModel.output
        
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(titleLabel)
        view.addSubview(colorTitleLabel)
        view.addSubview(shapeTitleLabel)
        view.addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
        }
        
        colorTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.54)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        shapeTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
