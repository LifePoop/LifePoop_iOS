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
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    @Inject(SharedDIContainer.shared) private var cheeringInfoUseCase: CheeringInfoUseCase
    @Inject(SharedDIContainer.shared) private var storyFeedUseCase: StoryFeedUseCase
    @Inject(SharedDIContainer.shared) private var stoolLogUseCase: StoolLogUseCase
    @Inject(HomeDIContainer.shared) private var friendListRepository: HomeRepository
    
    public init() { }
    
    public func fetchStoryFeeds() -> Observable<[StoryFeedEntity]> {
        return storyFeedUseCase.fetchStoryFeeds()
    }
    
    public func fetchCheeringInfo(at date: String) -> Observable<CheeringInfoEntity> {
        return userInfoUseCase.userInfo
            .compactMap { $0?.userId }
            .debug()
            .withUnretained(self)
            .flatMapLatest { `self`, userId in
                self.cheeringInfoUseCase.fetchCheeringInfo(userId: userId, date: date)
            }
            .asObservable()
    }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        return userInfoUseCase.userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.friendListRepository.fetchFriendList(accessToken: accessToken)
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchStoolLogs() -> Observable<[StoolLogEntity]> {
        return stoolLogUseCase
            .fetchMyLast7DaysStoolLogs()
    }
    
    public func postStoolLog(_ stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity> {
        return stoolLogUseCase.postStoolLog(stoolLogEntity: stoolLogEntity)
    }
    
    public func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem] {
        return stoolLogUseCase.convertToStoolLogItems(from: stoolLogsEntities)
    }
}
