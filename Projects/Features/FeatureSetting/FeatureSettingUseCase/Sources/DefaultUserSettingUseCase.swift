//
//  DefaultUserSettingUseCase.swift
//  FeatureSettingUseCase
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultUserSettingUseCase: UserSettingUseCase {
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var loginTypeUseCase: LoginTypeUseCase
    @Inject(SharedDIContainer.shared) private var autoLoginUseCase: AutoLoginUseCase
    @Inject(SharedDIContainer.shared) private var feedVisibilityUseCase: FeedVisibilityUseCase
    
    public init() { }
    
    public var nickname: BehaviorSubject<String?> {
        return nicknameUseCase.nickname
    }
    
    public var loginType: BehaviorSubject<LoginType?> {
        return loginTypeUseCase.loginType
    }
    
    public var isAutoLoginActivated: BehaviorSubject<Bool?> {
        return autoLoginUseCase.isAutoLoginActivated
    }
    
    public var feedVisibility: BehaviorSubject<FeedVisibility?> {
        return feedVisibilityUseCase.feedVisibility
    }
    
    public func updateNickname(to newNickname: String) {
        nicknameUseCase.updateNickname(to: newNickname)
    }
    
    public func updateLoginType(to newLoginType: LoginType) {
        loginTypeUseCase.updateLoginType(to: newLoginType)
    }
    
    public func updateIsAutoLoginActivated(to newValue: Bool) {
        autoLoginUseCase.updateIsAutoLoginActivated(to: newValue)
    }
    
    public func updateFeedVisibility(to newFeedVisibility: FeedVisibility) {
        feedVisibilityUseCase.updateFeedVisibility(to: newFeedVisibility)
    }
    
    public func configureDefaultUserSetting() {
        updateFeedVisibility(to: .public)
        updateIsAutoLoginActivated(to: true)
    }
}
