//
//  LoginUseCase.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol LoginUseCase {
    var userInfo: Observable<UserInfoEntity?> { get }
    func saveUserInfo(_ userInfo: UserInfoEntity) -> Completable
    func requestSignin(with userInfo: UserAuthInfoEntity) -> Observable<Bool>
    func fetchAccessToken(for loginType: LoginType) -> Observable<UserAuthInfoEntity?>
    func clearUserAuthInfoIfNeeded() -> Completable
}
