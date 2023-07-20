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
import Logger
import Utils

public final class FriendListViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let friendDidSelect = PublishRelay<IndexPath>()
        let invitationButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let showFriendList = PublishRelay<[FriendEntity]>()
        let setNavigationTitle = Observable.of(LocalizableString.friendsList)
        let showEmptyList = PublishRelay<Void>()
        let showToastMessge = PublishRelay<String>()
    }
    
    public struct State {
        let friendList = BehaviorRelay<[FriendEntity]>(value: [])
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    @Inject(FriendListDIContainer.shared) private var friendListUseCase: FriendListUseCase
    
    private weak var coordiantor: FriendListCoordinator?
    private var disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?) {
        self.coordiantor = coordinator
        bind(coordinator: coordinator)
    }
    
    private func bind(coordinator: FriendListCoordinator?) {
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { `self`, _ in self.friendListUseCase.fetchFriendList() }
            .withUnretained(self)
            .bind(onNext: { `self`, friendList in
                if friendList.isEmpty {
                    self.output.showEmptyList.accept(())
                } else {
                    self.state.friendList.accept(friendList)
                }
            })
            .disposed(by: disposeBag)
        
        input.invitationButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(
                    by: .shouldShowFriendInvitation(toastMessageStream: self.output.showToastMessge)
                )
            }
            .disposed(by: disposeBag)
        
        state.friendList
            .bind(to: output.showFriendList)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
