//
//  ProfileEditViewController.swift
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
import DesignSystemReactive
import EntityUIMapper
import Utils

public final class ProfileEditViewController: LifePoopViewController, ViewType {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.setUpProfile
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let profileImageEditView = ProfileImageEditView()
    
    private let nicknameTextField: ConditionalTextField = {
        let textField = ConditionalTextField()
        textField.title = LocalizableString.pleaseSetNickname
        textField.placeholder = LocalizableString.nicknamePlaceholder
        return textField
    }()
    
    private let editConfirmButton: LifePoopButton = {
        let button = LifePoopButton()
        button.setTitle(LocalizableString.doneModification, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let toastMessageLabel = ToastLabel()
    
    public var viewModel: ProfileEditViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
        addNotificationCenterKeyboardObserver()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ProfileEditViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.textChanged
            .bind(to: input.nicknameDidChange)
            .disposed(by: disposeBag)
        
        editConfirmButton.rx.tap
            .bind(to: input.editConfirmDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: ProfileEditViewModel) {
        let output = viewModel.output
        
        output.setProfileCharater
            .asSignal()
            .map { $0.largeImage }
            .emit(onNext: profileImageEditView.setProfileImageView)
            .disposed(by: disposeBag)
        
        output.setUserNickname
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.changeTextFieldStatus
            .map { $0.descriptionText }
            .bind(to: nicknameTextField.rx.status)
            .disposed(by: disposeBag)
        
        output.enableEditConfirmButton
            .bind(to: editConfirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showLodingIndicator
            .asSignal()
            .emit(onNext: editConfirmButton.showLoadingIndicator)
            .disposed(by: disposeBag)
        
        output.hideLodingIndicator
            .asSignal()
            .emit(onNext: editConfirmButton.hideLoadingIndicator)
            .disposed(by: disposeBag)
        
        output.showToastMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show(message:))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = LocalizableString.setUpProfileTitle
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(profileImageEditView)
        scrollContentView.addSubview(nicknameTextField)
        view.addSubview(editConfirmButton)
        view.addSubview(toastMessageLabel)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nicknameTextField.snp.bottom)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().inset(24)
        }
        
        profileImageEditView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageEditView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
        
        editConfirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(editConfirmButton.snp.top).offset(-16)
        }
    }
}

// MARK: - Add Tap Gesture

private extension ProfileEditViewController {
    func addTapGestures() {
        addProfileImageEditViewTapGesture()
        addViewTapGesture()
    }
    
    func addProfileImageEditViewTapGesture() {
        let profileImageEditViewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProfileEditTapGesture)
        )
        profileImageEditView.addGestureRecognizer(profileImageEditViewTapGesture)
    }
    
    func addViewTapGesture() {
        let viewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture(_:))
        )
        view.addGestureRecognizer(viewTapGesture)
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleProfileEditTapGesture() {
        view.endEditing(true)
        viewModel?.input.profileCharacterEditDidTap.accept(())
    }
}

// MARK: - Keyboard Notification Methods

private extension ProfileEditViewController {
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
        let textViewBottomY = nicknameTextField.convert(nicknameTextField.bounds, to: view).maxY
        
        if textViewBottomY > keyboardTopY {
            let extraSpace: CGFloat = 10.0
            let offsetY = textViewBottomY - keyboardTopY + extraSpace
            scrollView.contentOffset.y += offsetY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(.zero, animated: true)
    }
}
