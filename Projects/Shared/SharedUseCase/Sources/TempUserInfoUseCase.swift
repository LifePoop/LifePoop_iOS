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
    
    public func fetchUserInfo() -> Observable<UserInfoEntity> {
        return .just(UserInfoEntity(
            userId: 1212,
            nickname: "김상혁",
            authInfo: UserAuthInfoEntity(
                loginType: .kakao,
                accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIxMiwiaWF0IjoxNjk4NTA5ODQ4LCJleHAiOjE2OTg1MTA0NDgsInN1YiI6IkFDQ0VTU19UT0tFTiJ9.TowOskzwZA2_XxuKzU4G7qP-9UZnOH1hZGwP7ovOhME"
            )
        ))
    }
}
