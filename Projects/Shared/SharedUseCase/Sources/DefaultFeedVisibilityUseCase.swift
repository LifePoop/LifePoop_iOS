//
//  DefaultFeedVisibilityUseCase.swift
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

public final class DefaultFeedVisibilityUseCase: FeedVisibilityUseCase {
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var feedVisibility: BehaviorSubject<FeedVisibility?> {
        return BehaviorSubject<FeedVisibility?>(value: userDefaultsRepository.getValue(for: .feedVisibility))
    }
    
    public func updateFeedVisibility(to newFeedVisibility: FeedVisibility) {
        userDefaultsRepository.updateValue(for: .feedVisibility, with: newFeedVisibility)
    }
}
