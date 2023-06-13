//
//  FriendListViewModel.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureFriendListCoordinatorInterface
import FeatureFriendListDIContainer
import FeatureFriendListUseCase
import Utils

public final class FriendListViewModel: ViewModelType {
    
    public struct Input {
        let didSelectFirend = PublishRelay<FriendEntity>()
        let didTapInvitationButton = PublishRelay<Void>()
    }
    
    public struct Output {
        let navigationTitle = Observable.of("친구 목록")
        let friendList = BehaviorRelay<[FriendEntity]>(value: [])
    }
    
    @Inject(FriendListDIContainer.shared) private var friendListUseCase: FriendListUseCase
    private weak var coordiantor: FriendListCoordinator?
    
    private var disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?) {
        self.coordiantor = coordinator
        bind(coordinator: coordinator)
    }
    
    public let input = Input()
    public let output = Output()
    
    private func bind(coordinator: FriendListCoordinator?) {
        
        input.didTapInvitationButton
            .bind { _ in
                coordinator?.coordinate(by: .shouldShowFriendInvitation)
            }
            .disposed(by: disposeBag)
        
        friendListUseCase
            .fetchFriendList()
            .bind(to: output.friendList)
            .disposed(by: disposeBag)
    }
}
