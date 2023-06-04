//
//  UserInfoUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol UserInfoUseCase {
    var userInfo: Single<UserInfoEntity> { get }

    // TODO: KeyChain에서 인증정보 가져오기 때문에 해당 함수 수정 혹은 삭제 여부 확인 필요
    func updateLoginType(to newLoginType: LoginType)
}
