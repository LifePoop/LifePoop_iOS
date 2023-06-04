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
    func saveUserInfo(_ userInfo: UserInfoEntity) -> Single<Void>
    func fetchUserAuthInfo(for loginType: LoginType) -> Single<UserAuthInfoEntity?>
}
