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
                    self.getTimeDifference(fromDateOf: stoolStoryLogs[currentIndex].stoolLog.date)
                )
                self.output.updateFriendStoolLogSummary.accept(
                    LocalizableString.bowelMovementCountOfFriend(friend.nickname, totalCount)
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
                let shouldUpdateStoolLogTime = self.getTimeDifference(fromDateOf: stoolLog.date)
                
                return (
                    shouldUpdateShownStoolLog: stoolLog,
                    shouldEnableCheeringButton: isCheeringUpAvailable,
                    shouldHideCheeringLabel: shouldHideCheeringLabel,
                    shouldHideCheeringButton: shouldHideCheeringButton,
                    shouldUpdateStoolLogTime: shouldUpdateStoolLogTime
                )
            }
            .share()
        
        updateResult
            .map { $0.shouldUpdateShownStoolLog }
            .bind(to: output.updateShownStoolLog)
            .disposed(by: disposeBag)

        updateResult
            .map { $0.shouldHideCheeringLabel }
            .bind(to: output.hideCheeringLabel)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.shouldHideCheeringButton }
            .bind(to: output.hideCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.shouldEnableCheeringButton }
            .bind(to: output.enableCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.shouldHideCheeringLabel }
            .map {
                $0.shouldEnableCheeringButton ? LocalizableString.cheeringWithBoost
                                              : LocalizableString.doneCheeringWithBoost
            }
            .bind(to: output.updateCheeringLabelText)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.shouldHideCheeringButton }
            .map {
                $0.shouldEnableCheeringButton ? LocalizableString.boost
                                              : LocalizableString.doneBoost
            }
            .bind(to: output.updateCheeringButtonText)
            .disposed(by: disposeBag)

        updateResult
            .map { $0.shouldUpdateStoolLogTime }
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

private extension FriendStoolStoryViewModel {
    
    // MARK: 추후 서버에서 내려주는 값 맞춰서 로직 수정해야 함, 다국어 맞춰서 LocalizedString 형식으로 수정, Locale 수정
    func getTimeDifference(fromDateOf logDate: Date) -> String {
        // FIXME: date 타입이 String에서 Date로 변경된 것에 대한 로직 반영
        return "Temp Text"
    }
}
