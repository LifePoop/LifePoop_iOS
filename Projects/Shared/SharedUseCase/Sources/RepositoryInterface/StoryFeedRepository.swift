//
//  StoryFeedRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import RxSwift

public protocol StoryFeedRepository {
    func fetchStoryFeeds(accessToken: String) -> Single<[StoryFeedEntity]>
}
