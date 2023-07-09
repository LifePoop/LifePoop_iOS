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
        let didTapCloseButton = PublishRelay<Void>()
        let didTapScreen = PublishRelay<ScreenSide>()
        let didTapCheeringButton = PublishRelay<Void>()
        let didUpdateProgressState = PublishRelay<Int>()
    }
    
    public struct Output {
        let stoolStoryLogs = BehaviorRelay<[StoolStoryLogEntity]>(value: [])
        let shouldUpdateProgressState = PublishRelay<Int>()
        let shouldUpdateShownStoolLog = PublishRelay<StoolLogEntity>()
        let shouldHideCheeringButton = PublishRelay<Bool>()
        let shouldEnableCheeringButton = PublishRelay<Bool>()
        let shouldUpdateCheeringButtonText = BehaviorRelay<String>(value: LocalizableString.boost)
        let shouldHideCheeringLabel = PublishRelay<Bool>()
        let shouldUpdateCheeringLabelText = BehaviorRelay<String>(value: LocalizableString.cheeringWithBoost)
        let shouldUpdateStoolLogTime = PublishRelay<String>()
        let shouldUpdateFriendStoolLogSummary = PublishRelay<String>()
        let shouldShowLoadingIndicator = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private var hasDoneCheering = false
        
    private var disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?, friend: FriendEntity, stoolStoryLogs: [StoolStoryLogEntity]) {
        var stoolStoryLogs = stoolStoryLogs
        
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
            .filter { stoolStoryLogs.count > 0 }
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                let totalCount = stoolStoryLogs.count
                let currentIndex = 0
                
                self.output.shouldUpdateShownStoolLog.accept(stoolStoryLogs[currentIndex].stoolLog)
                self.output.shouldEnableCheeringButton.accept(
                    stoolStoryLogs[currentIndex].isCheeringUpAvailable
                )
                self.output.shouldUpdateStoolLogTime.accept(
                    self.getTimeDifference(fromDateOf: stoolStoryLogs[currentIndex].stoolLog.date ?? "")
                )
                self.output.shouldUpdateFriendStoolLogSummary.accept(
                    LocalizableString.bowelMovementCountOfFriend(friend.name, totalCount)
                )
            })
            .disposed(by: disposeBag)
        
        input.didTapScreen
            .withLatestFrom(input.didUpdateProgressState) { ($0, $1) }
            .map { side, currentIndex in
                let totalCount = stoolStoryLogs.count
                var currentIndex = currentIndex
                
                switch side {
                case .left:
                    currentIndex = currentIndex <= 0 ? 0 : currentIndex-1
                case .right:
                    currentIndex = currentIndex >= totalCount-1 ? totalCount : currentIndex+1
                }
                
                return currentIndex
            }
            .bind(to: output.shouldUpdateProgressState)
            .disposed(by: disposeBag)
        
        let updateResult = input.didUpdateProgressState
            .filter { $0 >= 0 }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .map { `self`, index in
                let stoolLog = stoolStoryLogs[index].stoolLog
                let isCheeringUpAvailable = stoolStoryLogs[index].isCheeringUpAvailable
                let shouldHideCheeringLabel = index < stoolStoryLogs.count-1
                let shouldHideCheeringButton = index < stoolStoryLogs.count-1
                let shouldUpdateStoolLogTime = self.getTimeDifference(fromDateOf: stoolLog.date ?? "")
                
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
            .bind(to: output.shouldUpdateShownStoolLog)
            .disposed(by: disposeBag)

        updateResult
            .map { $0.shouldHideCheeringLabel }
            .bind(to: output.shouldHideCheeringLabel)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.shouldHideCheeringButton }
            .bind(to: output.shouldHideCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .map { $0.shouldEnableCheeringButton }
            .bind(to: output.shouldEnableCheeringButton)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.shouldHideCheeringLabel }
            .map {
                $0.shouldEnableCheeringButton ? LocalizableString.cheeringWithBoost
                                              : LocalizableString.doneCheeringWithBoost
            }
            .bind(to: output.shouldUpdateCheeringLabelText)
            .disposed(by: disposeBag)
        
        updateResult
            .filter { !$0.shouldHideCheeringButton }
            .map {
                $0.shouldEnableCheeringButton ? LocalizableString.boost
                                              : LocalizableString.doneBoost
            }
            .bind(to: output.shouldUpdateCheeringButtonText)
            .disposed(by: disposeBag)

        updateResult
            .map { $0.shouldUpdateStoolLogTime }
            .bind(to: output.shouldUpdateStoolLogTime)
            .disposed(by: disposeBag)
        
        // MARK: 응원하기 버튼 터치 후 임시로 로딩 표시 띄우기 위한 로직, 추후 제거해야 함
        input.didTapCheeringButton
            .do(onNext: { [weak self] _ in
                self?.output.shouldShowLoadingIndicator.accept(true)
            })
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                guard let lastLog = stoolStoryLogs.popLast() else { return }
                let newLog = StoolStoryLogEntity(stoolLog: lastLog.stoolLog, isCheeringUpAvailable: false)
                stoolStoryLogs.append(newLog)
                self?.output.shouldShowLoadingIndicator.accept(false)
                self?.hasDoneCheering = true
                self?.output.shouldUpdateCheeringLabelText.accept(LocalizableString.doneCheeringWithBoost)
                self?.output.shouldUpdateCheeringButtonText.accept(LocalizableString.doneBoost)
            })
            .map { _ in false }
            .bind(to: output.shouldEnableCheeringButton)
            .disposed(by: disposeBag)
    }
}

private extension FriendStoolStoryViewModel {
    
    // MARK: 추후 서버에서 내려주는 값 맞춰서 로직 수정해야 함, 다국어 맞춰서 LocalizedString 형식으로 수정, Locale 수정
    func getTimeDifference(fromDateOf logDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a HH:mm"

        guard let logDate = dateFormatter.date(from: logDate) else { return "" }

        let currentDate = Date()
        let currentCalendar = Calendar.current
        let currentDateComponents = currentCalendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let timeComponents = currentCalendar.dateComponents([.hour, .minute], from: logDate)

        var mergedComponents = DateComponents()
        mergedComponents.year = currentDateComponents.year
        mergedComponents.month = currentDateComponents.month
        mergedComponents.day = currentDateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        
        guard let mergedDate = currentCalendar.date(from: mergedComponents) else { return "" }
        
        let timeDifference = currentDate.timeIntervalSince(mergedDate)

        return timeDifference >= 60*60 ? "\(Int(timeDifference / (60 * 60)))시간 전"
                                       : "\(Int(timeDifference / 60))분 전"
    }
}
