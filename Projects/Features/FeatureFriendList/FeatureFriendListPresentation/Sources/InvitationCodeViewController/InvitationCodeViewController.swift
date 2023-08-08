//
//  InvitationCodeViewController.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import DesignSystemReactive
import Utils

public final class InvitationCodeViewController: LifePoopViewController, ViewType {
    
    private let alertView = LifePoopTextFieldAlertView(type: .invitationCode, placeholder: "ex) vMXxaOXq")
    
    private var disposeBag = DisposeBag()
    public var viewModel: InvitationCodeViewModel?
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotificationObserver()
    }
    
    public func bindInput(to viewModel: InvitationCodeViewModel) {
        let input = viewModel.input
        
        rx.viewDidAppear
            .bind(to: input.viewDidAppear)
            .disposed(by: disposeBag)
        
        alertView.cancelButton.rx.tap
            .bind(to: input.didTapCancelButton)
            .disposed(by: disposeBag)
        
        alertView.confirmButton.rx.tap
            .bind(to: input.didTapConfirmButton)
            .disposed(by: disposeBag)
        
        alertView.rx.text
            .bind(to: input.didEnterInvitationCode)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: InvitationCodeViewModel) {
        let output = viewModel.output
        
        output.shouldDismissAlertView
            .bind(with: self, onNext: { `self`, _ in
                self.dismissEnteringCodePopup()
            })
            .disposed(by: disposeBag)
        
        output.shouldShowInvitationCodePopup
            .bind(with: self, onNext: { `self`, _ in
                self.showEnteringCodePopup()
            })
            .disposed(by: disposeBag)
        
        output.enableConfirmButton
            .bind(to: alertView.rx.isConfirmButtonEnabled)
            .disposed(by: disposeBag)
        
        output.hideWarningLabel
            .bind(to: alertView.rx.isWarningLabelhidden)
            .disposed(by: disposeBag)
        
        // TODO: 우선은 클립보드에 초대코드 복사된 것만 확인
        // 추후 서버에서 초대코드 생성되면 UseCase 거쳐서 textToShare 초기화하도록 수정할 예정
        output.shouldShowSharingActivityView
            .bind(with: self, onNext: { `self`, _ in
                self.showSharingPopup()
            })
            .disposed(by: disposeBag)
    }
    
    override public func configureUI() {
        super.configureUI()
        
        view.backgroundColor = .clear
        view.isOpaque = false
    }
}

private extension InvitationCodeViewController {
    
    func showEnteringCodePopup() {
        alertView.show(in: view)
        alertView.becomeFirstResponder()
    }
    
    func dismissEnteringCodePopup() {
        alertView.dismiss { [weak self] in
            self?.viewModel?.input.didCloseInvitationCodePopup.accept(())
        }
    }
    
    func showSharingPopup() {
        let textToShare = "Invitation Code"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        // MARK: 우선적으로 필요없는 타입 제외
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .airDrop,
            .openInIBooks,
            .saveToCameraRoll,
            .markupAsPDF
        ]
        
        activityViewController.completionWithItemsHandler = { [weak self] activity, success, _, error in
            if let error = error {
                self?.viewModel?.input.didCloseSharingPopup.accept(.failure(error: error))
                return
            }
            
            // MARK: 사용자가 동작을 취소한 경우에는 success = fail, presentedViewController != nil 인 상태
            guard success else {
                self?.dismissViewControllerIfNeeded()
                return
            }
            if activity == .copyToPasteboard {
                self?.viewModel?.input.didCloseSharingPopup.accept(.success(activity: .copying))
            } else {
                self?.viewModel?.input.didCloseSharingPopup.accept(.success(activity: .sharing))
            }
        }
        
        present(activityViewController, animated: true)
    }
    
    func dismissViewControllerIfNeeded() {
        if presentedViewController != nil { return }
        
        viewModel?.input.didCloseSharingPopup.accept(nil)
    }
}

// MARK: - Keyboard Notification Methods

private extension InvitationCodeViewController {
    
    func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDismiss),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardView = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = keyboardView?.cgRectValue.height else { return }
        
        let keyboardTopY = view.frame.maxY - keyboardHeight
        let alertViewBottomY = alertView.frame.maxY
        
        if alertViewBottomY > keyboardTopY {
            let extraSpace: CGFloat = 10.0
            let offsetY = alertViewBottomY - keyboardTopY + extraSpace
            
            UIView.animate(withDuration: 0.3, animations: {
                self.alertView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            })
        }
    }
    
    @objc func keyboardWillDismiss(_ notification: NSNotification) {
        self.alertView.transform = .identity
    }
}
