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

@available(*, deprecated, message: "탈퇴 사유 선택하지 않는 것으로 변경됨")
public final class WithdrawalViewController: LifePoopViewController, ViewType {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private lazy var reasonSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유 선택"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let reasonButtons = WithdrawReason.allCases.map {
        SelectableTextRadioButtonView(index: $0.index, title: $0.title)
    }
    
    private lazy var reasonSelectStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: reasonButtons)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let reasonTextView = FeedbackTextViewContainerView(
        placeholder: "이 외에 불편했던 점을 작성해주세요. (선택)",
        maximumTextCount: 100
    )
    
    private let withdrawAlertView = LifePoopAlertView(type: .withdraw)
    
    private lazy var withdrawButton: LifePoopButton = {
        let button = LifePoopButton(title: "탈퇴하기")
        button.isEnabled = false
        return button
    }()
    
    public var viewModel: WithdrawalViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        addNotificationCenterKeyboardObserver()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: WithdrawalViewModel) {
        let input = viewModel.input
        
        let selectedReasonIndex = reasonButtons.map { button in
            button.containerButton.rx.tap.map { button.index }
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
        title = LocalizableString.withdraw
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(reasonSelectLabel)
        scrollContentView.addSubview(reasonSelectStackView)
        scrollContentView.addSubview(reasonTextView)
        view.addSubview(withdrawButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reasonTextView.snp.bottom)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reasonSelectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(24)
        }
        
        reasonSelectStackView.snp.makeConstraints { make in
            make.top.equalTo(reasonSelectLabel.snp.bottom).offset(42)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonSelectStackView.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(181)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

// MARK: - Tap Gesture Methods

private extension WithdrawalViewController {
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard Notification Methods

private extension WithdrawalViewController {
    func addNotificationCenterKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrameNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardHeight = keyboardFrameNotification?.cgRectValue.height ?? .zero
        
        let keyboardTopY = view.frame.maxY - keyboardHeight
        let textViewBottomY = reasonTextView.convert(reasonTextView.bounds, to: view).maxY
        
        let offsetY = textViewBottomY - keyboardTopY
        scrollView.contentOffset.y += offsetY
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(.zero, animated: true)
    }
}
