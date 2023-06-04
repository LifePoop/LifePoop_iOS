//
//  DefaultNicknameUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import SharedDIContainer
import Utils

public final class DefaultNicknameUseCase: NicknameUseCase {
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var nickname: BehaviorSubject<String?> {
        return BehaviorSubject<String?>(value: userDefaultsRepository.getValue(for: .userNickname))
    }
    
    public func updateNickname(to newNickname: String) {
        userDefaultsRepository.updateValue(for: .userNickname, with: newNickname)
    }
}
