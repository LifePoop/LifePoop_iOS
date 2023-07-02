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
}
