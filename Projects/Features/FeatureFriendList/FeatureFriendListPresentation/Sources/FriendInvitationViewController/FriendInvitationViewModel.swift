//
//  FriendInvitationViewModel.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
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

public final class FriendInvitationViewModel: ViewModelType {
    
    public struct Input {
        let didSelectInvitationType = PublishRelay<InvitationType>()
    }
    
    public struct Output {
        let navitationTitle = Observable.of(LocalizableString.sendInvitation)
        let invitationTypes = Observable.of(InvitationType.allCases)
    }
    
    public let input = Input()
    public let output = Output()
    
    private var disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?, toastMessageStream: PublishRelay<String>) {
        bind(coordinator: coordinator, toastMessageStream: toastMessageStream)
    }
    
    private func bind(coordinator: FriendListCoordinator?, toastMessageStream: PublishRelay<String>) {
        
        input.didSelectInvitationType
            .bind(onNext: { invitationType in
                coordinator?.coordinate(by: .shouldShowInvitationCodePopup(type: invitationType, toastMessageStream: toastMessageStream))
            })
            .disposed(by: disposeBag)
    }
}
