//
//  DefaultStoolLogUseCase.swift
//  FeatureStoolLogUseCase
//
//  Created by 김상혁 on 2023/06/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureStoolLogDIContainer
import Utils

public protocol StoolLogUseCase {
    func post(stoolLog: StoolLogEntity) -> Completable
}

public final class DefaultStoolLogUseCase: StoolLogUseCase {
    
    @Inject(StoolLogDIContainer.shared) private var stoolLogRepository: StoolLogRepository
    
    public init() { }
    
    public func post(stoolLog: StoolLogEntity) -> Completable {
        return stoolLogRepository.post(stoolLog: stoolLog)
    }
}
