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
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let didEnterInvitationCode = PublishRelay<String>()
        let didTapConfirmButton = PublishRelay<Void>()
        let didTapCancelButton = PublishRelay<Void>()
        let didCloseSharingPopup = PublishRelay<Void>()
    }
    
    public struct Output {
        let placeholder = BehaviorRelay<String>(value: "")
        let shouldDismissAlertView = PublishRelay<Void>()
        let shouldShowInvitationCodePopup = PublishRelay<Void>()
        let shouldShowSharingActivityView = PublishRelay<Void>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?, invitationType: InvitationType, toastMessageStream: PublishRelay<String>) {
        
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
        
        Observable.merge(
            input.didTapCancelButton.asObservable(),
            input.didCloseSharingPopup.asObservable()
        )
        .bind(onNext: { [weak self] _ in
            self?.output.shouldDismissAlertView.accept(())
            coordinator?.coordinate(by: .shouldDismissInvitationCodePopup)
        })
        .disposed(by: disposeBag)
        
        input.didCloseSharingPopup
            .map { "초대코드 공유 완료" }
            .bind(to: toastMessageStream)
            .disposed(by: disposeBag)
        
        input.didTapConfirmButton
            .withLatestFrom(input.didEnterInvitationCode)
            .bind(onNext: { invitationCode in
                Logger.log(message: "초대코드 입력 확인 : \(invitationCode)", category: .default, type: .debug)
                coordinator?.coordinate(by: .shouldDismissInvitationCodePopup)
            })
            .disposed(by: disposeBag)
    }
    
    
}
