//
//  InvitationCodeViewModel.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureFriendListCoordinatorInterface
import FeatureFriendListDIContainer
import FeatureFriendListUseCase
import Logger
import Utils

public final class InvitationCodeViewModel: ViewModelType {
    
    enum SharingResult: CustomStringConvertible {
        case success(activity: Activity)
        case failure(error: Error?)
        
        enum Activity {
            case sharing
            case copying
        }
        
        var description: String {
            switch self {
            case .success(let activity):
                return activity == .copying ?
                LocalizableString.toastInvitationCodeCopySuccess :
                LocalizableString.toastInvitationCodeSharingSuccess
            case .failure:
                return LocalizableString.toastInvitationCodeSharingFail
            }
        }
    }
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let didEnterInvitationCode = PublishRelay<String>()
        let didTapConfirmButton = PublishRelay<Void>()
        let didTapCancelButton = PublishRelay<Void>()
        let didCloseSharingPopup = PublishRelay<SharingResult?>()
        let didCloseInvitationCodePopup = PublishRelay<Void>()
    }
    
    public struct Output {
        let placeholder = BehaviorRelay<String>(value: "")
        let shouldDismissAlertView = PublishRelay<Void>()
        let shouldShowInvitationCodePopup = PublishRelay<Void>()
        let shouldShowSharingActivityView = PublishRelay<Void>()
        let enableConfirmButton = PublishRelay<Bool>()
        let hideWarningLabel = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var disposeBag = DisposeBag()
    
    public init(
        coordinator: FriendListCoordinator?,
        invitationType: InvitationType,
        toastMessageStream: PublishRelay<String>
    ) {
        
        input.viewDidLoad
            .map { invitationType }
            .withUnretained(self)
            .bind(onNext: { `self`, invitationType in
                switch invitationType {
                case .sharingInvitationCode:
                    self.output.shouldShowSharingActivityView.accept(())
                case .enteringInvitationCode:
                    self.output.shouldShowInvitationCodePopup.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.didCloseSharingPopup
            .map { _ in Void() }
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .shouldDismissInvitationCodePopup)
            })
            .disposed(by: disposeBag)
        
        input.didCloseSharingPopup
            .compactMap { $0?.description }
            .bind(to: toastMessageStream)
            .disposed(by: disposeBag)
        
        input.didEnterInvitationCode
            .map { $0.count >= 8 }
            .bind(to: output.enableConfirmButton)
            .disposed(by: disposeBag)

        input.didEnterInvitationCode
            .map { $0.count <= 8 }
            .bind(to: output.hideWarningLabel)
            .disposed(by: disposeBag)
        
        input.didTapCancelButton
            .bind(to: output.shouldDismissAlertView)
            .disposed(by: disposeBag)

        input.didTapConfirmButton
            .withLatestFrom(input.didEnterInvitationCode)
            .do(onNext: { invitationCode in
                Logger.log(message: "초대코드 입력 확인 : \(invitationCode)", category: .default, type: .debug)
            })
            .map { _ in Void() }
            .bind(to: output.shouldDismissAlertView)
            .disposed(by: disposeBag)

        input.didCloseInvitationCodePopup
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .shouldDismissInvitationCodePopup)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
