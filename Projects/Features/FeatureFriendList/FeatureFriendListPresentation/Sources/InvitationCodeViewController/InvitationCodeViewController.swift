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
    
    private let textFieldAlertView = LifePoopTextFieldAlertView(
        type: .invitationCode,
        placeholder: "ex) vMXxaOXq"
    )
    
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
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .bind(to: input.viewDidAppear)
            .disposed(by: disposeBag)
        
        textFieldAlertView.cancelButton.rx.tap
            .bind(to: input.didTapCancelButton)
            .disposed(by: disposeBag)
        
        textFieldAlertView.confirmButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(to: input.didTapConfirmButton)
            .disposed(by: disposeBag)
        
        textFieldAlertView.rx.text
            .bind(to: input.didEnterInvitationCode)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: InvitationCodeViewModel) {
        let output = viewModel.output
        
        output.dismissAlertView
            .asSignal()
            .emit(with: self, onNext: { `self`, _ in
                self.dismissEnteringCodePopup()
            })
            .disposed(by: disposeBag)
        
        output.showInvitationCodePopup
            .asSignal()
            .emit(with: self, onNext: { `self`, _ in
                self.showEnteringCodePopup()
            })
            .disposed(by: disposeBag)
        
        output.enableConfirmButton
            .asSignal(onErrorJustReturn: false)
            .emit(to: textFieldAlertView.rx.isConfirmButtonEnabled)
            .disposed(by: disposeBag)
        
        output.hideWarningLabel
            .asSignal()
            .emit(to: textFieldAlertView.rx.isWarningLabelhidden)
            .disposed(by: disposeBag)
        
        output.showSharingActivityView
            .asSignal()
            .emit(with: self, onNext: { `self`, invitationText in
                self.showSharingPopup(with: invitationText)
            })
            .disposed(by: disposeBag)
        
        output.warningLabelText
            .asSignal(onErrorJustReturn: "")
            .emit(to: textFieldAlertView.rx.warningLabelText)
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
        textFieldAlertView.show(in: view) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        textFieldAlertView.becomeFirstResponder()
    }
    
    func dismissEnteringCodePopup() {
        textFieldAlertView.dismiss { [weak self] in
            self?.viewModel?.input.didCloseInvitationCodePopup.accept(())
        }
    }
    
    func showSharingPopup(with invitationText: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [invitationText],
            applicationActivities: nil
        )
        
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
                self?.viewModel?.input.didCloseSharingPopup.accept(
                    (activity == .copyToPasteboard) ? .invitationCodeCopyFail : .invitationCodeSharingFail
                )
                return
            }
            
            // MARK: 사용자가 동작을 취소한 경우에는 success = fail, presentedViewController != nil 인 상태
            guard success else {
                self?.dismissViewControllerIfNeeded()
                return
            }
            self?.viewModel?.input.didCloseSharingPopup.accept(
                (activity == .copyToPasteboard) ? .invitationCodeCopySuccess : .invitationCodeSharingSuccess
            )
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
        let alertViewBottomY = textFieldAlertView.frame.maxY
        
        if alertViewBottomY > keyboardTopY {
            let extraSpace: CGFloat = 10.0
            let offsetY = alertViewBottomY - keyboardTopY + extraSpace
            
            UIView.animate(withDuration: 0.3, animations: {
                self.textFieldAlertView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            })
        }
    }
    
    @objc func keyboardWillDismiss(_ notification: NSNotification) {
        self.textFieldAlertView.transform = .identity
    }
}
