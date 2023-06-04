//
//  DefaultAutoLoginUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import SharedDIContainer
import Utils

public final class DefaultAutoLoginUseCase: AutoLoginUseCase {
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var isAutoLoginActivated: BehaviorSubject<Bool?> {
        return BehaviorSubject<Bool?>(value: userDefaultsRepository.getValue(for: .isAutoLoginActivated))
    }
    
    public func updateIsAutoLoginActivated(to newValue: Bool) {
        userDefaultsRepository.updateValue(for: .isAutoLoginActivated, with: newValue)
    }
}
