//
//  DefaultNicknameUseCase.swift
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

public final class DefaultNicknameUseCase: NicknameUseCase {
    
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var nickname: Observable<String?> {
        return userDefaultsRepository
            .getValue(for: .userNickname)
            .logErrorIfDetected(category: .userDefaults)
            .asObservable()
    }
    
    public func updateNickname(to newNickname: String) -> Completable {
        return userDefaultsRepository
            .updateValue(for: .isAutoLoginActivated, with: newNickname)
            .logErrorIfDetected(category: .userDefaults)
    }
}
