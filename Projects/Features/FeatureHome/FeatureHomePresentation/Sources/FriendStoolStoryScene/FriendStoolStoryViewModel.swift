//
//  FriendStoolStoryViewModel.swift
//  FeatureHomePresentation
//
//  Created by Lee, Joon Woo on 2023/06/25.
//  Copyright © 2023 Lifepoo. All rights reserved.
//
import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeCoordinatorInterface
import SharedDIContainer
import SharedUseCase
import Utils

public final class FriendStoolStoryViewModel: ViewModelType {
    
    enum ScreenSide {
        case left
        case right
    }
    
    public struct Input {
        let viewDidLayoutSubviews = PublishRelay<Void>()
        let closeButtonDidTap = PublishRelay<Void>()
        let screenDidTap = PublishRelay<ScreenSide>()
        let cheeringButtonDidTap = PublishRelay<Void>()
        let progressStateDidUpdate = PublishRelay<Int>()
    }
    
    public struct Output {
        let stories = BehaviorRelay<[StoryEntity]>(value: [])
        let updateProgressState = PublishRelay<Int>()
        let updateShownStory = PublishRelay<StoryEntity>()
        let enableCheeringButton = BehaviorRelay<Bool>(value: true)
        let updateCheeringButtonText = BehaviorRelay<String>(value: LocalizableString.boost)
        let updateCheeringLabelText = BehaviorRelay<String>(value: LocalizableString.cheeringWithBoost)
        let updateStoolLogTime = PublishRelay<String>()
        let updateFriendStoolLogSummary = PublishRelay<String>()
        let showLoadingIndicator = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var hasDoneCheering = false

    @Inject(SharedDIContainer.shared) private var cheeringInfoUseCase: CheeringInfoUseCase
        
    private var disposeBag = DisposeBag()
    
    public init(
        coordinator: HomeCoordinator?,
        friendUserId: Int,
        stories: [StoryEntity],
        isCheered: Bool
    ) {
        bind(coordinator: coordinator, friendUserId: friendUserId, stories: stories, isCheered: isCheered)
    }
    
    private func bind(coordinator: HomeCoordinator?, friendUserId: Int, stories: [StoryEntity], isCheered: Bool) {
        
        Observable.just(isCheered)
            .withUnretained(self)
            .bind(onNext: { `self`, isCheered in
                self.output.enableCheeringButton.accept(!isCheered)
                
                let cheeringLabelText = isCheered ? LocalizableString.doneCheeringWithBoost
                                                  : LocalizableString.cheeringWithBoost
                self.output.updateCheeringLabelText.accept(cheeringLabelText)
                
                let cheeringButtonText = isCheered ? LocalizableString.doneBoost
                                                   : LocalizableString.boost
                self.output.updateCheeringButtonText.accept(cheeringButtonText)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .storyCloseButtonDidTap)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .map { stories }
            .bind(to: output.stories)
            .disposed(by: disposeBag)
        
        input.viewDidLayoutSubviews
            .take(1)
            .compactMap { stories.first }
            .withUnretained(self)
            .bind(onNext: { `self`, firstStory in
                self.output.updateShownStory.accept(firstStory)
                self.output.updateStoolLogTime.accept(
                    firstStory.date.localizedTimeDifferenceSinceCurrentDateString
                )
            })
            .disposed(by: disposeBag)
        
        input.screenDidTap
            .withLatestFrom(input.progressStateDidUpdate) { ($0, $1) }
            .map { side, currentIndex in
                let totalCount = stories.count
                var currentIndex = currentIndex
                
                switch side {
                case .left:
                    currentIndex = currentIndex <= 0 ? 0 : currentIndex - 1
                case .right:
                    currentIndex = currentIndex >= totalCount - 1 ? totalCount : currentIndex + 1
                }
                
                return currentIndex
            }
            .bind(to: output.updateProgressState)
            .disposed(by: disposeBag)
        
        let updateResult = input.progressStateDidUpdate
            .filter { $0 >= 0 }
            .observe(on: MainScheduler.asyncInstance)
            .map { index in
                let story = stories[index]
                let updateStoolLogTime = story.date.localizedTimeDifferenceSinceCurrentDateString
                
                return (
                    updateShownStory: story,
                    updateStoolLogTime: updateStoolLogTime
                )
            }
            .share()
        
        updateResult
            .map { $0.updateShownStory }
            .bind(to: output.updateShownStory)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.updateShownStory }
            .map { (color: $0.color.description, shape: $0.shape.description) }
            .map { LocalizableString.stoolLogDescription($0.color, $0.shape) }
            .bind(to: output.updateFriendStoolLogSummary)
            .disposed(by: disposeBag)
            
        updateResult
            .map { $0.updateStoolLogTime }
            .bind(to: output.updateStoolLogTime)
            .disposed(by: disposeBag)
        
        input.cheeringButtonDidTap
            .withUnretained(self)
            .do(onNext: { `self`, _ in
                self.output.showLoadingIndicator.accept(true)
            })
            .flatMapLatest { `self`, _ in
                self.cheeringInfoUseCase.requestCheering(withIdOf: friendUserId)
            }
            .withUnretained(self)
            .do(onNext: { `self`, _ in
                self.output.showLoadingIndicator.accept(false)
            })
            .bind(onNext: { `self`, isSuccess in
                self.output.enableCheeringButton.accept(!isSuccess)
                
                let cheeringLabelText = isSuccess ? LocalizableString.doneCheeringWithBoost
                                                  : LocalizableString.cheeringWithBoost
                self.output.updateCheeringLabelText.accept(cheeringLabelText)
                
                let cheeringButtonText = isSuccess ? LocalizableString.doneBoost
                                                   : LocalizableString.boost
                self.output.updateCheeringButtonText.accept(cheeringButtonText)
                
                if isSuccess {
                    NotificationCenter.default.post(name: .updateCheering, object: friendUserId)
                }
            })
            .disposed(by: disposeBag)
    }
}
