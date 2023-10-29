//
//  TempUserInfoUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/09/15.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxSwift

import CoreEntity

public final class TempUserInfoUseCase: UserInfoUseCase {
    public init() { }
    
    // FIXME: Keychain 값으로 수정
    public func fetchUserInfo() -> Observable<UserInfoEntity> {
        return .just(UserInfoEntity(
            userId: 1212,
            nickname: "김상혁",
            authInfo: UserAuthInfoEntity(
                loginType: .kakao,
                accessToken: "accessToken"
            )
        ))
    }
}
