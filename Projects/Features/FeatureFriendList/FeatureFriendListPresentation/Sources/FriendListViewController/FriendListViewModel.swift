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
        let addingFriendDidComplete = PublishRelay<Void>()
    }
    
    public struct Output {
        let shouldLoadingIndicatorAnimating = PublishRelay<Bool>()
        let showFriendList = PublishRelay<[FriendEntity]>()
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
    
    private weak var coordinator: FriendListCoordinator?
    private var disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?) {
        self.coordinator = coordinator
        bind(coordinator: coordinator)
    }
    
    private func bind(coordinator: FriendListCoordinator?) {
        
        input.viewDidLoad
            .map { _ in true }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        let updateFriendList = Observable<Void>.merge(
            input.viewDidLoad.asObservable(),
            input.addingFriendDidComplete.asObservable()
        ).share()
        
        let fetchedFriendList = updateFriendList
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.friendListUseCase.fetchFriendList()
            }
            .share()
        
        fetchedFriendList
            .compactMap { $0.element }
            .debug()
            .bind(to: state.friendList)
            .disposed(by: disposeBag)
        
        fetchedFriendList
            .compactMap { $0.error }
            .map { _ in [] }
            .bind(to: state.friendList)
            .disposed(by: disposeBag)
        
        fetchedFriendList
            .compactMap { $0.error }
            .toastMessageMap(to: .friendList(.fetchFriendListFail) )
            .bind(to: output.showToastMessge)
            .disposed(by: disposeBag)
        
        fetchedFriendList
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        input.invitationButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(
                    by: .showFriendInvitation(
                        toastMessageStream: self.output.showToastMessge,
                        friendListUpdateStream: self.input.addingFriendDidComplete
                    )
                )
            }
            .disposed(by: disposeBag)
        
        input.friendDidSelect
            .withLatestFrom(state.friendList) { ($0, $1) }
            .map { indexPath, friendList in
                friendList[indexPath.row]
            }
            .bind { friendEntity in
                coordinator?.coordinate(by: .showFriendsStoolLog(friendEntity: friendEntity))
            }
            .disposed(by: disposeBag)
        
        state.friendList
            .filter { !$0.isEmpty }
            .bind(to: output.showFriendList)
            .disposed(by: disposeBag)
        
        state.friendList
            .filter { $0.isEmpty }
            .map { _ in }
            .bind(to: output.showEmptyList)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
