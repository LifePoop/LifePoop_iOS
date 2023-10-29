//
//  DefaultHomeUseCase.swift
//  FeatureHomeUseCase
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureHomeDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultHomeUseCase: HomeUseCase {
    
    @Inject(SharedDIContainer.shared) private var stoolLogUseCase: StoolLogUseCase
    @Inject(SharedDIContainer.shared) private var friendListRepository: FriendListRepository
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        return friendListRepository
            .fetchFriendList()
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchStoolLogs() -> Observable<[StoolLogEntity]> {
        return stoolLogUseCase
            .fetchMyLast7DaysStoolLogs()
    }
    
    // TODO: 삭제 또는 수정 예정
    public func fetchStoolLogsOfSelectedFriend(_ friend: FriendEntity) -> Observable<[StoolStoryLogEntity]> {
        return stoolLogUseCase
            .fetchAllUserStoolLogs(userID: friend.userID)
            .withUnretained(self)
            .compactMap { `self`, friendStoolLogs in
                self.convertToStoryLogs(friendStoolLogs)
            }
    }
    
    public func postStoolLog(_ stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity> {
        return stoolLogUseCase
            .postStoolLog(stoolLogEntity: stoolLogEntity)
    }
    
    public func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem] {
        return stoolLogUseCase.convertToStoolLogItems(from: stoolLogsEntities)
    }
}

private extension DefaultHomeUseCase {
    // TODO: 삭제 예정
    func convertToStoryLogs(_ stoolLogs: [StoolLogEntity]) -> [StoolStoryLogEntity] {
        let sortedStoolLogs = stoolLogs.sorted { $0.date < $1.date }
        // TODO: 추후 서버에서 DTO 내려줄 때, '힘주기' 여부가 포함되야 하고, 아래 isFirst 조건과 함께 고려해서 isCheeringUpAvailable값이 결정되야 함
        // 우선은 isLast여부로만 힘주기 가능여부 판단하도록 처리
        let storyLogs = sortedStoolLogs.enumerated().map { index, stoolLog in
            let isLast = index == stoolLogs.count-1
            return StoolStoryLogEntity(stoolLog: stoolLog, isCheeringUpAvailable: isLast)
        }
        
        return storyLogs
    }
}
