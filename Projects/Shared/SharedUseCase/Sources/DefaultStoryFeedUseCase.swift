//
//  DefaultStoryFeedUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//


import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public protocol StoryFeedUseCase {
    func fetchStoryFeeds() -> Observable<[StoryFeedEntity]>
}

public final class DefaultStoryFeedUseCase: StoryFeedUseCase {
    
    @Inject(SharedDIContainer.shared) private var storyFeedRepository: StoryFeedRepository
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public init() { }
    
    public func fetchStoryFeeds() -> Observable<[StoryFeedEntity]> {
        return userInfoUseCase
            .userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMap { `self`, accessToken in
                self.storyFeedRepository.fetchStoryFeeds(accessToken: accessToken)
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
}
