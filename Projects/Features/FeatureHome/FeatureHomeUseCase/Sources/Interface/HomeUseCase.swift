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
    func fetchCheeringInfo(at date: String) -> Observable<CheeringInfoEntity>
    func fetchFriendList() -> Observable<[FriendEntity]>
    func fetchStoolLogs() -> Observable<[StoolLogEntity]>
    
    // FIXME: 선택된 친구의 스토리 불러오는 코드 - 삭제 또는 수정 필요
    func fetchStoolLogsOfSelectedFriend(_ friend: FriendEntity) -> Observable<[StoolStoryLogEntity]>
    
    func postStoolLog(_ stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity>
    func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem]
}
