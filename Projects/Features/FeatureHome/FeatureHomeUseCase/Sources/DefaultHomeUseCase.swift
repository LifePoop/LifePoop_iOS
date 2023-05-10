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
import Utils

public final class DefaultHomeUseCase: HomeUseCase {
    
    @Inject(HomeDIContainer.shared) private var homeRepository: HomeRepository
    
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
}
