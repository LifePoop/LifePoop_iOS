//
//  HomeCoordinatorAction.swift
//  FeatureHomeCoordinatorInterface
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay

import CoreEntity

public enum HomeCoordinateAction {
    case flowDidStart(animated: Bool)
    case flowDidFinish
    case cheeringButtonDidTap(storyFeedsStream: BehaviorRelay<[StoryFeedEntity]>)
    case stoolLogButtonDidTapInReportView
    case stoolLogButtonDidTap(stoolLogsRelay: BehaviorRelay<[StoolLogEntity]>)
    case settingButtonDidTap
    case reportButtonDidTap
    case storyFeedButtonDidTap(friendUserId: Int, stories: [StoryEntity], isCheered: Bool)
    case storyCloseButtonDidTap
}
