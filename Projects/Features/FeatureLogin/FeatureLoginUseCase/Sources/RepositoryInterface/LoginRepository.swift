//
//  LoginRepository.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity
import Utils

public protocol LoginRepository: AnyObject {
    
    func requestAuthInfoWithOAuthAccessToken(with userAuthInfo: OAuthTokenInfo) -> Single<UserAuthInfoEntity?>
    func fetchOAuthAccessToken(for loginType: LoginType) -> Single<String>
}
