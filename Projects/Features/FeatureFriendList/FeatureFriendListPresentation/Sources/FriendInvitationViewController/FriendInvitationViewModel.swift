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
        let navitationTitle = Observable.of("초대장 보내기")
        let invitationTypes = Observable.of(InvitationType.allCases)
    }
    
    public let input = Input()
    public let output = Output()
    
    private var disposeBag = DisposeBag()
    
    public init() {
        bind()
    }
    
    private func bind() {
        
        input.didSelectInvitationType
            .bind(onNext: { invitationType in
                switch invitationType {
                case .sharingInvitationCode:
                    Logger.log(message: "초대코드 공유하기", category: .default, type: .default)
                case .enteringInvitationCode:
                    Logger.log(message: "친구 추가 코드 입력하기", category: .default, type: .default)
                }
            })
            .disposed(by: disposeBag)
    }
}
