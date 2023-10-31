//
//  DefaultStoryFeedRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import SharedUseCase
import Utils

public final class DefaultStoryFeedRepository: StoryFeedRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var storyFeedEntityMapper: AnyDataMapper<StoryFeedDTO, StoryFeedEntity>
    
    public init() { }
    
    public func fetchStoryFeeds(accessToken: String) -> Single<[StoryFeedEntity]> {
        return urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchStoryFeed(accessToken: accessToken))
            .decodeMap([StoryFeedDTO].self)
            .transformMap(storyFeedEntityMapper)
    }
}
