//
//  HomeUseCase.swift
//  FeatureHomeUseCase
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol HomeUseCase {
    func fetchStoryFeeds() -> Observable<[StoryFeedEntity]>
    func fetchCheeringInfo(at date: String) -> Observable<CheeringInfoEntity>
    func fetchFriendList() -> Observable<[FriendEntity]>
    func fetchStoolLogs() -> Observable<[StoolLogEntity]>
    func postStoolLog(_ stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity>
    func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem]
}
