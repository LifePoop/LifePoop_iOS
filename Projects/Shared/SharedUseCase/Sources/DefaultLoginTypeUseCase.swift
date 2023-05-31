//
//  DefaultLoginTypeUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import Utils

public final class DefaultLoginTypeUseCase: LoginTypeUseCase {
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var loginType: BehaviorSubject<LoginType?> {
        return BehaviorSubject<LoginType?>(value: userDefaultsRepository.getValue(for: .userLoginType))
    }
    
    public func updateLoginType(to newLoginType: LoginType) {
        userDefaultsRepository.updateValue(for: .userLoginType, with: newLoginType)
    }
}
