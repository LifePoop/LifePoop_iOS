//
//  StoolLogRepository.swift
//  FeatureStoolLogUseCase
//
//  Created by 김상혁 on 2023/06/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol StoolLogRepository {
    func post(stoolLog: StoolLogEntity) -> Completable
}
