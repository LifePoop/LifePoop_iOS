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
        let didSelectFirend = PublishRelay<FriendEntity>()
        let didTapInvitationButton = PublishRelay<Void>()
        let didCompleteAddingFriend = PublishRelay<Void>()
    }
    
    public struct Output {
        let navigationTitle = Observable.of(LocalizableString.friendsList)
        let showFriendList = BehaviorRelay<[FriendEntity]>(value: [])
        let showEmptyList = PublishRelay<Void>()
        let showToastMessge = PublishRelay<String>()
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
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(
                    by: .showFriendInvitation(
                        toastMessageStream: self.output.showToastMessge,
                        friendListUpdateStream: self.input.didCompleteAddingFriend
                    )
                )
            }
            .disposed(by: disposeBag)
        
        let updateFriendList = Observable<Void>.merge(
            input.viewDidLoad.asObservable(),
            input.didCompleteAddingFriend.asObservable()
        ).share()
        
        updateFriendList
            .withUnretained(self)
            .flatMap { `self`, _ in self.friendListUseCase.fetchFriendList() }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { `self`, friendList in
                if friendList.isEmpty {
                    self.output.showEmptyList.accept(())
                } else {
                    self.output.showFriendList.accept(friendList)
                }
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
