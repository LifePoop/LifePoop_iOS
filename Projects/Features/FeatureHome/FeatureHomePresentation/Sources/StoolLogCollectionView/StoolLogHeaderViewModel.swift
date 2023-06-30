//
//  StoolLogHeaderViewModel.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeCoordinatorInterface
import Logger
import Utils

public final class StoolLogHeaderViewModel: ViewModelType {
    
    public struct Input {
        let viewDidRefresh = PublishRelay<Void>()
        let viewDidLoad = PublishRelay<Void>()
        let inviteFriendButtonDidTap = PublishRelay<Void>()
        let cheeringButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let toggleFriendListCollectionView = PublishRelay<Bool>()
        let updateUserProfileCharacter = PublishRelay<FriendEntity>()
        let updateFriends = PublishRelay<(user: FriendEntity, friends: [FriendEntity])>()
        let setDateDescription = PublishRelay<String>()
        let setFriendsCheeringDescription = PublishRelay<String>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let userProfileCharacter = BehaviorRelay<FriendEntity?>(value: nil)
        let friends = BehaviorRelay<(user: FriendEntity, friends: [FriendEntity])?>(value: nil)
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    private weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        
        let viewDidLoadOrRefresh = Observable.merge(
            input.viewDidLoad.asObservable(),
            input.viewDidRefresh.asObservable()
        )
        .share()
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.friends)
            .compactMap { $0 }
            .bind(to: output.updateFriends)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .map { Date().localizedString }
            .map { LocalizableString.stoolDiaryFor($0) }
            .bind(to: output.setDateDescription)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .map { "강시온님 외 33명이 응원하고 있어요!" } // FIXME: UseCase 구현하여 변경
            .bind(to: output.setFriendsCheeringDescription)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.friends)
            .compactMap { $0?.friends }
            .map { $0.isEmpty }
            .bind(to: output.toggleFriendListCollectionView)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.userProfileCharacter)
            .compactMap { $0 }
            .bind(to: output.updateUserProfileCharacter)
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.inviteFriendButtonDidTap.asObservable(),
            input.cheeringButtonDidTap.asObservable()
        )
        .bind { coordinator?.coordinate(by: .cheeringButtonDidTap) }
        .disposed(by: disposeBag)
        
        state.friends
            .compactMap { $0 }
            .bind(to: output.updateFriends)
            .disposed(by: disposeBag)
        
        state.friends
            .compactMap { $0?.friends }
            .map { $0.isEmpty }
            .bind(to: output.toggleFriendListCollectionView)
            .disposed(by: disposeBag)
        
        state.userProfileCharacter
            .compactMap { $0 }
            .bind(to: output.updateUserProfileCharacter)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
