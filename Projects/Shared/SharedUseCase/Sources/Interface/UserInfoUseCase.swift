//
//  UserInfoUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/09/15.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol UserInfoUseCase {
    func fetchUserInfo() -> Observable<UserInfoEntity>
}
