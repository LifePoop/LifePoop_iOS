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
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class InvitationCodeViewModel: ViewModelType {
    
    enum ActionResult: CustomStringConvertible {
        case success(activity: Activity)
        case failure(activity: Activity, error: Error?)
        
        enum Activity {
            case sharing
            case copying
            case addingFriend
        }
        
        var description: String {
            switch self {
            case .success(let activity):
                switch activity {
                case .sharing:
                    return LocalizableString.toastInvitationCodeSharingSuccess
                case .copying:
                    return LocalizableString.toastInvitationCodeCopySuccess
                case .addingFriend:
                    return LocalizableString.toastAddingFriendSuccess
                }
            case .failure:
                
                return LocalizableString.toastInvitationCodeSharingFail
            }
        }
    }
    
    public struct Input {
        let viewDidAppear = PublishRelay<Void>()
        let didEnterInvitationCode = PublishRelay<String>()
        let didTapConfirmButton = PublishRelay<Void>()
        let didTapCancelButton = PublishRelay<Void>()
        let didCloseSharingPopup = PublishRelay<ActionResult?>()
        let didCloseInvitationCodePopup = PublishRelay<Void>()
    }
    
    public struct Output {
        let placeholder = BehaviorRelay<String>(value: "")
        let dismissAlertView = PublishRelay<Void>()
        let showInvitationCodePopup = PublishRelay<Void>()
        let showSharingActivityView = PublishRelay<Void>()
        let enableConfirmButton = PublishRelay<Bool>()
        let hideWarningLabel = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private (set)var invitationCode: String = ""
    
    @Inject(SharedDIContainer.shared) private var friendListUseCase: FriendListUseCase
    
    private var disposeBag = DisposeBag()
    
    public init(
        coordinator: FriendListCoordinator?,
        invitationType: InvitationType,
        toastMessageStream: PublishRelay<String>,
        friendListUpdateStream: PublishRelay<Void>
    ) {
        
        input.viewDidAppear
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.friendListUseCase.invitationCode
            }
            .withUnretained(self)
            .bind(onNext: { `self`, invitationCode in
                self.invitationCode = invitationCode
            })
            .disposed(by: disposeBag)
        
        input.viewDidAppear
            .map { invitationType }
            .withUnretained(self)
            .bind(onNext: { `self`, invitationType in
                switch invitationType {
                case .sharingInvitationCode:
                    self.output.showSharingActivityView.accept(())
                case .enteringInvitationCode:
                    self.output.showInvitationCodePopup.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.didCloseSharingPopup
            .map { _ in Void() }
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .dismissInvitationCodePopup)
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
            .bind(to: output.dismissAlertView)
            .disposed(by: disposeBag)

        input.didTapConfirmButton
            .withLatestFrom(input.didEnterInvitationCode)
            .withUnretained(self)
            .flatMapLatest { `self`, invitationCode in
                self.friendListUseCase.requestAddingFriend(with: invitationCode)
            }
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] _ in
                self?.output.dismissAlertView.accept(())
            })
            .map { isSuccess -> String in
                let actionResult: ActionResult = isSuccess ?
                    .success(activity: .addingFriend) :
                    .failure(activity: .addingFriend, error: nil)
                return actionResult.description
            }
            .bind(onNext: { toastMessage in
                toastMessageStream.accept(toastMessage)
                friendListUpdateStream.accept(())
            })
            .disposed(by: disposeBag)

        input.didCloseInvitationCodePopup
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .dismissInvitationCodePopup)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
