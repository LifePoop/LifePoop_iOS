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
import FeatureHomeDIContainer
import FeatureHomeUseCase
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
        let stoolStoryLogs = BehaviorRelay<[StoolStoryLogEntity]>(value: [])
        let updateProgressState = PublishRelay<Int>()
        let updateShownStoolLog = PublishRelay<StoolLogEntity>()
        let hideCheeringButton = PublishRelay<Bool>()
        let enableCheeringButton = PublishRelay<Bool>()
        let updateCheeringButtonText = BehaviorRelay<String>(value: LocalizableString.boost)
        let hideCheeringLabel = PublishRelay<Bool>()
        let updateCheeringLabelText = BehaviorRelay<String>(value: LocalizableString.cheeringWithBoost)
        let updateStoolLogTime = PublishRelay<String>()
        let updateFriendStoolLogSummary = PublishRelay<String>()
        let showLoadingIndicator = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var hasDoneCheering = false
        
    private var disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?, friend: FriendEntity, stoolStoryLogs: [StoolStoryLogEntity]) {
        var stoolStoryLogs = stoolStoryLogs
        
        input.closeButtonDidTap
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
            .filter { stoolStoryLogs.count > 0 }
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                let totalCount = stoolStoryLogs.count
                let currentIndex = 0
                
                self.output.updateShownStoolLog.accept(stoolStoryLogs[currentIndex].stoolLog)
                self.output.enableCheeringButton.accept(
                    stoolStoryLogs[currentIndex].isCheeringUpAvailable
                )
                self.output.updateStoolLogTime.accept(
                    stories[currentIndex].date.localizedTimeDifferenceSinceCurrentDateString
                )
            })
            .disposed(by: disposeBag)
        
        input.screenDidTap
            .withLatestFrom(input.progressStateDidUpdate) { ($0, $1) }
            .map { side, currentIndex in
                let totalCount = stoolStoryLogs.count
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
            .withUnretained(self)
            .map { `self`, index in
                let stoolLog = stoolStoryLogs[index].stoolLog
                let isCheeringUpAvailable = stoolStoryLogs[index].isCheeringUpAvailable
                let shouldHideCheeringLabel = index < stoolStoryLogs.count - 1
                let shouldHideCheeringButton = index < stoolStoryLogs.count - 1
                let updateStoolLogTime = story.date.localizedTimeDifferenceSinceCurrentDateString
                
                return (
                    updateShownStoolLog: stoolLog,
                    enableCheeringButton: isCheeringUpAvailable,
                    hideCheeringLabel: shouldHideCheeringLabel,
                    hideCheeringButton: shouldHideCheeringButton,
                    updateStoolLogTime: shouldUpdateStoolLogTime
                )
            }
            .share()
        
        updateResult
            .map { $0.updateShownStoolLog }
            .bind(to: output.updateShownStoolLog)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.updateShownStoolLog }
            .map { (color: $0.color.description, shape: $0.shape.description) }
            .map { LocalizableString.stoolLogDescription($0.color, $0.shape) }
            .bind(to: output.updateFriendStoolLogSummary)
            .disposed(by: disposeBag)
            
        updateResult
            .map { $0.hideCheeringLabel }
            .bind(to: output.hideCheeringLabel)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.hideCheeringButton }
            .bind(to: output.hideCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.enableCheeringButton }
            .bind(to: output.enableCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.hideCheeringLabel }
            .map {
                $0.enableCheeringButton ? LocalizableString.cheeringWithBoost
                                        : LocalizableString.doneCheeringWithBoost
            }
            .bind(to: output.updateCheeringLabelText)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.hideCheeringButton }
            .map {
                $0.enableCheeringButton ? LocalizableString.boost
                                        : LocalizableString.doneBoost
            }
            .bind(to: output.updateCheeringButtonText)
            .disposed(by: disposeBag)

        updateResult
            .map { $0.updateStoolLogTime }
            .bind(to: output.updateStoolLogTime)
            .disposed(by: disposeBag)
        
        // MARK: 응원하기 버튼 터치 후 임시로 로딩 표시 띄우기 위한 로직, 추후 제거해야 함
        input.cheeringButtonDidTap
            .do(onNext: { [weak self] _ in
                self?.output.showLoadingIndicator.accept(true)
            })
            .do(onNext: { [weak self] _ in
                guard let lastLog = stoolStoryLogs.popLast() else { return }
                let newLog = StoolStoryLogEntity(stoolLog: lastLog.stoolLog, isCheeringUpAvailable: false)
                stoolStoryLogs.append(newLog)
                self?.output.showLoadingIndicator.accept(false)
                self?.hasDoneCheering = true
                self?.output.updateCheeringLabelText.accept(LocalizableString.doneCheeringWithBoost)
                self?.output.updateCheeringButtonText.accept(LocalizableString.doneBoost)
            })
            .map { _ in false }
            .bind(to: output.enableCheeringButton)
            .disposed(by: disposeBag)
    }
}
