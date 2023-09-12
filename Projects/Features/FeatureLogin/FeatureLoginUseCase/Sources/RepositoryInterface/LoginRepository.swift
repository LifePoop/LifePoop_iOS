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
    
    func requestSignin(with userAuthInfo: UserAuthInfoEntity) -> Single<Bool>
    func fetchAccessToken(for loginType: LoginType) -> Single<String>
}
