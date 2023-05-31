//
//  UserSettingUseCase.swift
//  FeatureSettingUseCase
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol UserSettingUseCase {
    var nickname: BehaviorSubject<String?> { get }
    var loginType: BehaviorSubject<LoginType?> { get }
    var isAutoLoginActivated: BehaviorSubject<Bool?> { get }
    var feedVisibility: BehaviorSubject<FeedVisibility?> { get }
    func updateNickname(to newNickname: String)
    func updateLoginType(to newLoginType: LoginType)
    func updateIsAutoLoginActivated(to isActivated: Bool)
    func updateFeedVisibility(to newFeedVisibility: FeedVisibility)
}
