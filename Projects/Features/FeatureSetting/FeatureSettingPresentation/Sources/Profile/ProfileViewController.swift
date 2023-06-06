//
//  ProfileViewController.swift
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
import EntityUIMapper
import Utils

public final class ProfileViewController: LifePoopViewController, ViewType {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필을 설정해주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let profileImageEditView = ProfileImageEditView()
    
    private let nicknameTextField: ConditionalTextField = {
        let textField = ConditionalTextField()
        textField.title = "닉네임을 설정해주세요"
        textField.placeholder = "닉네임 입력하기"
        textField.status = .none(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")
        return textField
    }()
    
    private let editConfirmButton: LifePoopButton = {
        let button = LifePoopButton(title: "수정 완료")
        button.isEnabled = false
        return button
    }()
    
    public var viewModel: ProfileViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
        addNotificationCenterKeyboardObserver()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ProfileViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx // TODO: How?
        
    }
    
    public func bindOutput(from viewModel: ProfileViewModel) {
        let output = viewModel.output
        
        output.setProfileCharater
            .map { $0.image }
            .bind(onNext: profileImageEditView.setProfileImageView)
            .disposed(by: disposeBag)
        
        output.setUserNickname
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = "프로필 정보 수정"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(profileImageEditView)
        scrollContentView.addSubview(nicknameTextField)
        view.addSubview(editConfirmButton)
        
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
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        profileImageEditView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageEditView.snp.bottom).offset(55)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
        
        editConfirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - Add Tap Gesture

private extension ProfileViewController {
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

private extension ProfileViewController {
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

extension Reactive where Base == ConditionalTextField { // FIXME: 공통 모듈로 분리
    var text: ControlProperty<String> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.text ?? "" },
            setter: { insertField, text in
                insertField.text = text
            }
        )
    }
}
