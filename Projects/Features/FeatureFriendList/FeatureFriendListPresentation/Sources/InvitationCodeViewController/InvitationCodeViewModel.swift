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
    
    enum ActionResult {
        
        case invitationCodeCopySuccess
        case invitationCodeCopyFail
        case invitationCodeSharingSuccess
        case invitationCodeSharingFail
        case addingFriendSuccess
        case addingFriendFail(reason: AddingFrieldFailureReason)

        enum AddingFrieldFailureReason {
            case duplicateCode
            case nonExistingCode
            case invalidResult
            
            init(error: InvitationError) {
                switch error {
                case .alreadyAddedFriend:
                    self = .duplicateCode
                case .nonExistingCode:
                    self = .nonExistingCode
                case .invalidResult:
                    self = .invalidResult
                }
            }
        }

        var toatMessage: ToastMessage {
            switch self {
            case .invitationCodeCopySuccess:
                return .invitation(.invitationCodeCopySuccess)
            case .invitationCodeCopyFail:
                return .invitation(.invitationCodeCopyFail)
            case .invitationCodeSharingSuccess:
                return .invitation(.invitationCodeSharingSuccess)
            case .invitationCodeSharingFail:
                return .invitation(.invitationCodeSharingFail)
            case .addingFriendSuccess:
                return .invitation(.addingFriendSuccess)
            case .addingFriendFail(let reason):
                switch reason {
                case .duplicateCode:
                    return .invitation(.addingFriendFail(reason: .alreadyAddedFriend))
                case .nonExistingCode:
                    return .invitation(.addingFriendFail(reason: .invalidInvitationCode))
                case .invalidResult:
                    return .invitation(.addingFriendFail(reason: .invalidResult))
                }
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
        let enableConfirmButton = BehaviorRelay<Bool>(value: false)
        let hideWarningLabel = PublishRelay<Bool>()
        let warningLabelText = BehaviorRelay<String>(value: "")
    }
    
    public let input = Input()
    public let output = Output()
    
    private (set)var invitationCode: String = ""
    
    @Inject(FriendListDIContainer.shared) private var friendListUseCase: FriendListUseCase
    
    private var disposeBag = DisposeBag()
    
    public init(
        coordinator: FriendListCoordinator?,
        invitationType: InvitationType,
        toastMessageStream: PublishRelay<ToastMessage>,
        friendListUpdateStream: PublishRelay<Void>
    ) {
        
        friendListUseCase.invitationCode
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
            .compactMap { $0?.toatMessage }
            .bind(to: toastMessageStream)
            .disposed(by: disposeBag)
        
        let invitationCodeInputResult = input.didEnterInvitationCode
            .skip(1)
            .withUnretained(self)
            .flatMap { `self`, invitationCode in
                self.friendListUseCase.checkInvitationCodeValidation(invitationCode)
            }
            .share()
        
        invitationCodeInputResult
            .map { $0.isValid }
            .bind(to: output.enableConfirmButton)
            .disposed(by: disposeBag)

        invitationCodeInputResult
            .map { $0.isValid }
            .bind(to: output.hideWarningLabel)
            .disposed(by: disposeBag)
        
        invitationCodeInputResult
            .filter { !$0.isValid }
            .compactMap {
                switch $0 {
                case .codeOfSelf:
                    return LocalizableString.cannotEnterCodeOfSelf
                case .invalidLength:
                    return LocalizableString.shouldEnterValidLengthOfCode
                default:
                    return nil
                }
            }
            .bind(to: output.warningLabelText)
            .disposed(by: disposeBag)
        
        input.didTapCancelButton
            .bind(to: output.dismissAlertView)
            .disposed(by: disposeBag)

        input.didTapConfirmButton
            .withLatestFrom(input.didEnterInvitationCode)
            .withUnretained(self)
            .flatMapLatest { `self`, invitationCode in
                self.friendListUseCase.requestAddingFriend(with: invitationCode)
                    .map { isSuccess -> ActionResult in
                        let actionResult: ActionResult = isSuccess ?
                            .addingFriendSuccess :
                            .addingFriendFail(reason: .invalidResult)
                        
                        return actionResult
                    }
                    .catch { error in
                        guard let error = error as? InvitationError else {
                            return .just(.addingFriendFail(reason: .invalidResult))
                        }
                        
                        return .just(.addingFriendFail(reason: .init(error: error)))
                    }
            }
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] _ in
                self?.output.dismissAlertView.accept(())
            })
            .map { $0.toatMessage }
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
