//
//  WithdrawalViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class WithdrawalViewController: LifePoopViewController, ViewType {
    
    private lazy var reasonSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유 선택"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let reasonButtons = WithdrawReason.allCases.map {
        SelectableTextRadioButton(index: $0.index, title: $0.title)
    }
    
    private lazy var reasonSelectStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: reasonButtons)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    //TODO: placeholder textview 타입 별도로 만들기 (isEditing에 따라 placeholer, textColor 변경하기)
    private lazy var reasonTextView: UITextView = {
        let textView = UITextView()
        let placeholder = "이 외에 불편했던 점을 작성해주세요. (선택)"
        let placeholderColor = ColorAsset.gray800.color
        textView.textColor = placeholderColor
        textView.text = placeholder
        textView.font = .systemFont(ofSize: 14)
        textView.contentInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        textView.backgroundColor = ColorAsset.gray200.color
        textView.layer.cornerRadius = 6
        return textView
    }()
    
    private let withdrawAlertView = LifePoopAlertView(type: .withdraw)
    
    private lazy var withdrawButton: LifePoopButton = {
        let button = LifePoopButton(title: "탈퇴하기")
        button.isEnabled = false
        return button
    }()
    
    public var viewModel: WithdrawalViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: WithdrawalViewModel) {
        let input = viewModel.input
        
        let selectedReasonIndex = reasonButtons.map { button in
            button.rx.tap.map { button.index }
        }
        Observable.merge(selectedReasonIndex)
            .bind(to: input.reasonDidSelectAt)
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .bind(to: input.withdrawButtonDidTap)
            .disposed(by: disposeBag)
        
        withdrawAlertView.cancelButton.rx.tap
            .bind(to: input.withdrawCancelButtonDidTap)
            .disposed(by: disposeBag)
        
        withdrawAlertView.confirmButton.rx.tap
            .bind(to: input.withdrawConfirmButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: WithdrawalViewModel) {
        let output = viewModel.output
        
        output.selectReasonAt
            .withUnretained(self)
            .bind { `self`, index in
                self.reasonButtons.forEach { $0.toggleRadioButton(isSelected: false) }
                self.reasonButtons[index].toggleRadioButton(isSelected: true)
            }
            .disposed(by: disposeBag)
        
        output.enableWithdrawButton
            .bind(to: withdrawButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showWithdrawAlert
            .withUnretained(self)
            .bind { `self`, _ in
                self.withdrawAlertView.show(in: self.view)
            }
            .disposed(by: disposeBag)
        
        output.dismissWithdrawAlert
            .bind(onNext: withdrawAlertView.dismiss)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
        
    public override func configureUI() {
        super.configureUI()
        title = "탈퇴하기"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(reasonSelectLabel)
        view.addSubview(reasonSelectStackView)
        view.addSubview(reasonTextView)
        view.addSubview(withdrawButton)
        
        reasonSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        reasonSelectStackView.snp.makeConstraints { make in
            make.top.equalTo(reasonSelectLabel.snp.bottom).offset(42)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonSelectStackView.snp.bottom).offset(35)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}
