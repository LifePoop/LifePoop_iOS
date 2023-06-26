//
//  FeedbackViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class FeedbackViewController: LifePoopViewController, ViewType {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "라이푸에게 제안하고 싶은 내용이 있다면 이야기해 주세요!"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = .zero
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.gray600.color
        label.text = "소중한 의견을 바탕으로 더 건강한 배변일지 기록 및 공유 서비스가 되도록 하겠습니다."
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = .zero
        return label
    }()
    
    private let suggestionTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "제안 유형"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let suggestionButton = SuggestionButton()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let suggestionTextView = FeedbackTextViewContainerView(
        placeholder: "제안하고 싶은 내용을 입력해주세요.",
        maximumTextCount: 200
    )
    
    private let sendButton: LifePoopButton = {
        let button = LifePoopButton(title: "보내기")
        button.isEnabled = false
        return button
    }()
    
    public var viewModel: FeedbackViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        addNotificationCenterKeyboardObserver()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: FeedbackViewModel) {
        let input = viewModel.input
        
        suggestionButton.rx.tap
            .bind(to: input.suggestionButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FeedbackViewModel) {
        let output = viewModel.output
        
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = LocalizableString.sendUsFeedback
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(descriptionLabel)
        scrollContentView.addSubview(suggestionTypeLabel)
        scrollContentView.addSubview(suggestionButton)
        scrollContentView.addSubview(contentLabel)
        scrollContentView.addSubview(suggestionTextView)
        view.addSubview(sendButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(suggestionTextView.snp.bottom)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        suggestionTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(42)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        suggestionButton.snp.makeConstraints { make in
            make.top.equalTo(suggestionTypeLabel.snp.bottom).offset(14)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(suggestionButton.snp.bottom).offset(26)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        suggestionTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(14)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(181)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

// MARK: - Tap Gesture Methods

private extension FeedbackViewController {
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard Notification Methods

private extension FeedbackViewController {
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
        let textViewBottomY = suggestionTextView.convert(suggestionTextView.bounds, to: view).maxY
        
        let offsetY = textViewBottomY - keyboardTopY
        scrollView.contentOffset.y += offsetY
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(.zero, animated: true)
    }
}
