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
    
    private let alertView = LifePoopTextFieldAlertView(type: .invitationCode, placeholder: "ex) vMXxOXq")
    
    private var disposeBag = DisposeBag()
    public var viewModel: InvitationCodeViewModel?
    
    public func bindInput(to viewModel: InvitationCodeViewModel) {
        let input = viewModel.input
        
        rx.viewDidAppear
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.keyboardWillShow(_:)),
                    name: UIResponder.keyboardWillShowNotification, object: nil
                )
            })
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
            .bind(onNext: alertView.dismiss)
            .disposed(by: disposeBag)
        
        output.shouldShowInvitationCodePopup
            .bind(onNext: showEnteringCodePopup)
            .disposed(by: disposeBag)
        
        // TODO: 우선은 클립보드에 초대코드 복사된 것만 확인
        // 추후 서버에서 초대코드 생성되면 UseCase 거쳐서 textToShare 초기화하도록 수정할 예정
        output.shouldShowSharingActivityView
            .bind(onNext: showSharingPopup)
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
            guard success else {
                self?.viewModel?.input.didCloseSharingPopup.accept(.failure(error: error))
                return
            }
    
            if activity == .copyToPasteboard {
                self?.viewModel?.input.didCloseSharingPopup.accept(.success(activity: .copying))
            } else {
                self?.viewModel?.input.didCloseSharingPopup.accept(.success(activity: .sharing))
            }
    }
        
        self.present(activityViewController, animated: true)
    }
}

private extension InvitationCodeViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardView = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let keyboardRect = keyboardView.cgRectValue

        let keyboardMinY = keyboardRect.minY
        let alertViewMaxY = alertView.frame.maxY
        let marginOfError: CGFloat = 20
        let alertViewNeedsToGoUp = keyboardMinY <= alertViewMaxY + marginOfError
        
        if alertViewNeedsToGoUp {
            alertView.moveUp(to: 30)
        }
    }
}
