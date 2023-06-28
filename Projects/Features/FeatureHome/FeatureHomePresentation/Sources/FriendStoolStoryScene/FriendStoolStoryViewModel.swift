//
//  FriendStoolStoryViewModel.swift
//  FeatureHomePresentation
//
//  Created by Lee, Joon Woo on 2023/06/25.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeCoordinatorInterface
import FeatureHomeDIContainer
import FeatureHomeUseCase
import Utils

public final class FriendStoolStoryViewModel: ViewModelType {
    
    enum ScreenSide {
        case left
        case right
    }
    
    struct ProgressState {
        let currentIndex: Int
        let totalCount: Int
    }
    
    public struct Input {
        let viewDidLayoutSubviews = PublishRelay<Void>()
        let didTapCloseButton = PublishRelay<Void>()
        let didTapScreen = PublishRelay<ScreenSide>()
        let didTapCheeringButton = PublishRelay<Void>()
    }
    
    public struct Output {
        let stoolStoryLogs = BehaviorRelay<[StoolStoryLogEntity]>(value: [])
        let shouldUpdateProgressState = PublishRelay<ProgressState>()
        let shouldUpdateShownStoolLog = PublishRelay<StoolLogEntity>()
        let shouldEnableCheeringButton = PublishRelay<Bool>()
        let shouldUpdateFriendStoolLogSummary = PublishRelay<String>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?, friend: FriendEntity, stoolStoryLogs: [StoolStoryLogEntity]) {
        
        input.didTapCloseButton
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .storyCloseButtonDidTap)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .map { stoolStoryLogs }
            .bind(to: output.stoolStoryLogs)
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .map { stoolStoryLogs.count }
            .filter { $0 > 0 }
            .map { ProgressState(currentIndex: 0, totalCount: $0) }
            .withUnretained(self)
            .bind(onNext: { `self`, progressState in
                self.output.shouldUpdateProgressState.accept(progressState)
                self.output.shouldUpdateShownStoolLog.accept(stoolStoryLogs[progressState.currentIndex].stoolLog)
                self.output.shouldEnableCheeringButton.accept(
                    stoolStoryLogs[progressState.currentIndex].isCheeringUpAvailable
                )
                self.output.shouldUpdateFriendStoolLogSummary.accept(
                    LocalizableString.bowelMovementCountOfFriend(friend.name, progressState.totalCount)
                )
            })
            .disposed(by: disposeBag)
        
        let progressState = input.didTapScreen
            .withLatestFrom(output.shouldUpdateProgressState) {
                (side: $0, progressState: $1)
            }
            .map { side, progressState in
                let totalCount = progressState.totalCount
                var currentIndex = progressState.currentIndex
                
                switch side {
                case .left:
                    currentIndex = currentIndex <= 0 ? 0 : currentIndex-1
                case .right:
                    currentIndex = currentIndex >= totalCount-1 ? totalCount-1 : currentIndex+1
                }
                return ProgressState(currentIndex: currentIndex, totalCount: totalCount)
            }
            .share()
        
        progressState
            .bind(to: output.shouldUpdateProgressState)
            .disposed(by: disposeBag)
        
        progressState
            .map { $0.currentIndex }
            .withLatestFrom(output.stoolStoryLogs) { $1[$0].stoolLog }
            .bind(to: output.shouldUpdateShownStoolLog)
            .disposed(by: disposeBag)
        
        progressState
            .map { $0.currentIndex }
            .withLatestFrom(output.stoolStoryLogs) { $1[$0].isCheeringUpAvailable }
            .bind(to: output.shouldEnableCheeringButton)
            .disposed(by: disposeBag)
    }
}
