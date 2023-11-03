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
        
        let cheeringInfo = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.cheeringInfoUseCase.fetchCheeringInfo(
                    userId: friendEntity.id,
                    date: Date().dateString
                )
            }
            .share()
        
        cheeringInfo
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
        
        fetchedStoolLogs
            .compactMap { $0.error }
            .toastMessageMap(to: .stoolLog(.fetchStoolLogFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        fetchedStoolLogs
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State
        
        state.friendStoolLogheaderViewModel
            .compactMap { $0 }
            .bind(to: output.updateFriendStoolLogheaderViewModel)
            .disposed(by: disposeBag)
        
        state.stoolLogs
            .filter { $0.isEmpty }
            .map { _ in [StoolLogItem(itemState: .empty, section: .today)] }
            .bind(to: output.updateStoolLogs)
            .disposed(by: disposeBag)
        
        state.stoolLogs
            .filter { !$0.isEmpty }
            .map { $0.map { StoolLogItem(itemState: .stoolLog($0), section: .today) } }
            .bind(to: output.updateStoolLogs)
            .disposed(by: disposeBag)
    }
}
