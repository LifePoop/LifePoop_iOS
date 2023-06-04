//
//  FeedVisibilityUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol FeedVisibilityUseCase {
    var feedVisibility: BehaviorSubject<FeedVisibility?> { get }
    func updateFeedVisibility(to newFeedVisibility: FeedVisibility)
}
