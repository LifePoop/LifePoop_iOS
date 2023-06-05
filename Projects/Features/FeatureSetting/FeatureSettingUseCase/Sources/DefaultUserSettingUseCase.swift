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
    
    public var nickname: Observable<String?> {
        return nicknameUseCase.nickname
    }
    
    public var loginType: Observable<LoginType?> {
        return loginTypeUseCase.loginType
    }
    
    public var isAutoLoginActivated: Observable<Bool?> {
        return autoLoginUseCase.isAutoLoginActivated
    }
    
    public var feedVisibility: Observable<FeedVisibility?> {
        return feedVisibilityUseCase.feedVisibility
    }
    
    public func updateNickname(to newNickname: String) -> Completable {
        return nicknameUseCase.updateNickname(to: newNickname)
    }
    
    public func updateLoginType(to newLoginType: LoginType) -> Completable {
        return loginTypeUseCase.updateLoginType(to: newLoginType)
    }
    
    public func updateIsAutoLoginActivated(to newValue: Bool) -> Completable {
        return autoLoginUseCase.updateIsAutoLoginActivated(to: newValue)
    }
    
    public func updateFeedVisibility(to newFeedVisibility: FeedVisibility) -> Completable {
        return feedVisibilityUseCase.updateFeedVisibility(to: newFeedVisibility)
    }
    
    public func configureDefaultUserSetting() -> Completable {
        return Completable.zip(
            updateFeedVisibility(to: .public),
            updateIsAutoLoginActivated(to: true)
        )
    }
}
