//
//  MockStoolLogRepository.swift
//  FeatureStoolLogRepository
//
//  Created by 김상혁 on 2023/06/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureStoolLogUseCase
import Utils

public final class MockStoolLogRepository: StoolLogRepository {
    
    public init() { }
    
    public func post(stoolLog: StoolLogEntity) -> Completable {
        return Completable
            .empty()
            .delay(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
    }
}
