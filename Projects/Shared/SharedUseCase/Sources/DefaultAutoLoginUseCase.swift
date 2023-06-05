//
//  DefaultAutoLoginUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import Logger
import SharedDIContainer
import Utils

public final class DefaultAutoLoginUseCase: AutoLoginUseCase {
    
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var isAutoLoginActivated: Observable<Bool?> {
        return userDefaultsRepository
            .getValue(for: .isAutoLoginActivated)
            .logErrorIfDetected(category: .userDefaults)
            .asObservable()
    }
    
    public func updateIsAutoLoginActivated(to isActivated: Bool) -> Completable {
        return userDefaultsRepository
            .updateValue(for: .isAutoLoginActivated, with: isActivated)
            .logErrorIfDetected(category: .userDefaults)
    }
}
