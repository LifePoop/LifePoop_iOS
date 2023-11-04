//
//  FriendStoolLogViewModel.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureFriendListCoordinatorInterface
import SharedDIContainer
import SharedUseCase
import Utils

public final class FriendStoolLogViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let shouldLoadingIndicatorAnimating = PublishRelay<Bool>()
        let updateStoolLogs = PublishRelay<[StoolLogItem]>()
        let updateFriendStoolLogheaderViewModel = PublishRelay<FriendStoolLogHeaderViewModel>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let friendStoolLogheaderViewModel = BehaviorRelay<FriendStoolLogHeaderViewModel?>(value: nil)
        let stoolLogs = BehaviorRelay<[StoolLogEntity]>(value: [])
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    private let friendEntity: FriendEntity
    
    @Inject(SharedDIContainer.shared) private var stoolLogUseCase: StoolLogUseCase
    @Inject(SharedDIContainer.shared) private var cheeringInfoUseCase: CheeringInfoUseCase
    
    private weak var coordinator: FriendListCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: FriendListCoordinator?, friendEntity: FriendEntity) {
        self.coordinator = coordinator
        self.friendEntity = friendEntity
        
        // MARK: - Bind Input
        
        input.viewDidLoad
            .map { _ in true }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        let fetchedStoolLogs = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.stoolLogUseCase.fetchUserStoolLogs(
                    userID: friendEntity.id,
                    date: Date().dateString
                )
            }
            .share()
        
        let fetchedCheeringInfo = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.cheeringInfoUseCase.fetchCheeringInfo(
                    userId: friendEntity.id,
                    date: Date().dateString
                )
            }
            .share()
        
        fetchedCheeringInfo
            .compactMap { $0.element }
            .withLatestFrom(fetchedStoolLogs.compactMap { $0.element }) { ($0, $1) }
            .map { cheeringInfo, stoolLogs in
                FriendStoolLogHeaderViewModel(
                    friendNickname: friendEntity.nickname,
                    isStoolLogEmpty: stoolLogs.isEmpty,
                    cheeringFriendCount: cheeringInfo.count,
                    firstCheeringCharacter: cheeringInfo.firstFriendProfileCharacter,
                    secondCheeringCharacter: cheeringInfo.secondFriendProfileCharacter
                )
            }
            .bind(to: state.friendStoolLogheaderViewModel)
            .disposed(by: disposeBag)
        
        fetchedStoolLogs
            .compactMap { $0.element }
            .bind(to: state.stoolLogs)
            .disposed(by: disposeBag)
        
        fetchedStoolLogs
            .compactMap { $0.error }
            .map { _ in [] }
            .bind(to: state.stoolLogs)
            .disposed(by: disposeBag)
        
        Observable.merge(
            fetchedCheeringInfo.compactMap { $0.error },
            fetchedStoolLogs.compactMap { $0.error }
        )
        .toastMessageMap(to: .stoolLog(.fetchStoolLogFail))
        .bind(to: output.showErrorMessage)
        .disposed(by: disposeBag)
        
        Observable.merge(
            fetchedCheeringInfo.map { $0.isStopEvent },
            fetchedStoolLogs.map { $0.isStopEvent }
        )
        .filter { $0 }
        .map { _ in false }
        .bind(to: output.shouldLoadingIndicatorAnimating)
        .disposed(by: disposeBag)
        
        // MARK: - Bind State
        
        Observable.combineLatest(
            state.friendStoolLogheaderViewModel.compactMap { $0 },
            state.stoolLogs
        )
        .map { headerViewModel, stoolLogs -> ([StoolLogItem], FriendStoolLogHeaderViewModel) in
            let stoolLogItems = stoolLogs.isEmpty ? [StoolLogItem(itemState: .empty, section: .today)] :
                stoolLogs.map { StoolLogItem(itemState: .stoolLog($0), section: .today) }
            return (stoolLogItems, headerViewModel)
        }
        .bind { [weak self] stoolLogItems, headerViewModel in
            self?.output.updateFriendStoolLogheaderViewModel.accept(headerViewModel)
            self?.output.updateStoolLogs.accept(stoolLogItems)
        }
        .disposed(by: disposeBag)
    }
}
