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
import FeatureHomeDIContainer
import FeatureHomeUseCase
import Logger
import Utils

public final class StoolLogHeaderViewModel: ViewModelType {
    
    public struct Input {
        let viewDidRefresh = PublishRelay<Void>()
        let viewDidLoad = PublishRelay<Void>()
        let viewDidFinishLayoutSubviews = PublishRelay<Void>()
        let inviteFriendButtonDidTap = PublishRelay<Void>()
        let cheeringButtonDidTap = PublishRelay<Void>()
        let storyFeedCellDidTap = PublishRelay<IndexPath>()
    }
    
    public struct Output {
        let showInviteFriendUI = PublishRelay<Void>()
        let isStoryFeedEmpty = PublishRelay<Bool>()
        let updateCheeringProfileCharacters = PublishRelay<(ProfileCharacter?, ProfileCharacter?)>()
        let updateCheeringFriendNameAndCount = PublishRelay<(name: String, count: Int)>()
        let showEmptyCheeringInfo = PublishRelay<Void>()
        let updateStoryFeeds = PublishRelay<[StoryFeedEntity]>()
        let setDateDescription = PublishRelay<String>()
        let setFriendsCheeringDescription = PublishRelay<String>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let cheeringInfo = BehaviorRelay<CheeringInfoEntity?>(value: nil)
        let friends = BehaviorRelay<[FriendEntity]>(value: [])
        let storyFeeds = BehaviorRelay<[StoryFeedEntity]>(value: [])
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    private weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    
    // FIXME: 선택된 친구의 스토리 불러오는 코드 구현 이후 삭제
    @Inject(HomeDIContainer.shared) private var homeUseCase: HomeUseCase
    
    public init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        
        let viewDidLoadOrRefresh = Observable.merge(
            input.viewDidLoad.asObservable(),
            input.viewDidRefresh.asObservable()
        )
        .share()
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.storyFeeds)
            .compactMap { $0 }
            .bind(to: output.updateStoryFeeds)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .compactMap { Date().koreanDateString }
            .map { LocalizableString.stoolDiaryFor($0) }
            .bind(to: output.setDateDescription)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.storyFeeds)
            .map { $0.isEmpty }
            .bind(to: output.isStoryFeedEmpty)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.friends)
            .filter { $0.isEmpty }
            .map { _ in }
            .bind(to: output.showInviteFriendUI)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.cheeringInfo)
            .compactMap { $0 }
            .filter { $0.count > .zero }
            .map { ($0.firstFriendProfileCharacter, $0.secondFriendProfileCharacter) }
            .bind(to: output.updateCheeringProfileCharacters)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withLatestFrom(state.cheeringInfo)
            .compactMap { $0 }
            .filter { $0.count > .zero }
            .map { (name: $0.friendName ?? "", count: $0.extraCount) }
            .bind(to: output.updateCheeringFriendNameAndCount)
            .disposed(by: disposeBag)
        
        viewDidLoadOrRefresh
            .withUnretained(self)
            .filter { `self`, _ in
                !self.state.friends.value.isEmpty
            }
            .withLatestFrom(state.cheeringInfo)
            .compactMap { $0 }
            .filter { $0.count == .zero }
            .map { _ in }
            .bind(to: output.showEmptyCheeringInfo)
            .disposed(by: disposeBag)
        
        input.storyFeedCellDidTap
            .map { $0.item }
            .withLatestFrom(state.storyFeeds) { $1[$0] }
            .bind(onNext: { storyFeed in
                coordinator?.coordinate(
                    by: .storyFeedButtonDidTap(stories: storyFeed.stories, isCheered: storyFeed.isCheered)
                )
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.inviteFriendButtonDidTap.asObservable(),
            input.cheeringButtonDidTap.asObservable()
        )
        .bind { coordinator?.coordinate(by: .cheeringButtonDidTap) }
        .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
