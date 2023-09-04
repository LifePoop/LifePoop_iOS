//
//  DefaultHomeUseCase.swift
//  FeatureHomeUseCase
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity
import FeatureHomeDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultHomeUseCase: HomeUseCase {
    
    @Inject(HomeDIContainer.shared) private var homeRepository: HomeRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        return homeRepository
            .fetchFriendList()
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchStoolLogs() -> Observable<[StoolLogEntity]> {
        return homeRepository
            .fetchStoolLogs()
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchUserCharacter() -> Observable<ProfileCharacter?> {
        return userDefaultsRepository
            .getValue(for: .profileCharacter)
            .logErrorIfDetected(category: .userDefaults)
            .asObservable()
    }
    
    public func fetchStoolLogsOfSelectedFriend(_ friend: FriendEntity) -> Observable<[StoolStoryLogEntity]> {
        return homeRepository
            .fetchStoolLogsOfSelectedFriend(friend)
            .asObservable()
            .logErrorIfDetected(category: .network)
            .compactMap { [weak self] in self?.convertToStoryLogs($0) }
    }
}

private extension DefaultHomeUseCase {
    
    func convertToStoryLogs(_ stoolLogs: [StoolLogEntity]) -> [StoolStoryLogEntity] {
        
        let sortedStoolLogs = stoolLogs.sorted {
            guard
                let lhsDate = $0.date,
                let rhsDate = $1.date
            else { return false }
            return lhsDate < rhsDate
        }
        
        // TODO: 추후 서버에서 DTO 내려줄 때, '힘주기' 여부가 포함되야 하고, 아래 isFirst 조건과 함께 고려해서 isCheeringUpAvailable값이 결정되야 함
        // 우선은 isLast여부로만 힘주기 가능여부 판단하도록 처리
        let storyLogs = sortedStoolLogs.enumerated().map { index, stoolLog in
            let isLast = index == stoolLogs.count-1
            return StoolStoryLogEntity(stoolLog: stoolLog, isCheeringUpAvailable: isLast)
        }
        
        return storyLogs
    }
}
