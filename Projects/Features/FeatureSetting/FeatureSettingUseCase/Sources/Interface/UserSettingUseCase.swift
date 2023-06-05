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
    var nickname: Observable<String?> { get }
    var loginType: Observable<LoginType?> { get }
    var isAutoLoginActivated: Observable<Bool?> { get }
    var feedVisibility: Observable<FeedVisibility?> { get }
    func updateNickname(to newNickname: String) -> Completable
    func updateLoginType(to newLoginType: LoginType) -> Completable
    func updateIsAutoLoginActivated(to isActivated: Bool) -> Completable
    func updateFeedVisibility(to newFeedVisibility: FeedVisibility) -> Completable
}
