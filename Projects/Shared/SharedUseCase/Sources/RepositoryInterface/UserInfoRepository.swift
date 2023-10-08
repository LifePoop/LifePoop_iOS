//
//  UserInfoRepository.swift
//  SharedUseCase
//
//  Created by Lee, Joon Woo on 2023/10/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import RxSwift

public protocol UserInfoRepository: AnyObject {
    
    /** refresh token으로 서버로부터 access token, refresh token 업데이트 */
    func requestRefreshingUserAuthInfo(with authInfo: UserAuthInfoEntity) -> Single<UserAuthInfoEntity?>
    
    /** 전달된 refresh tokenm, access token으로 서버로부터 해당되는 사용자 정보 요청 */
    func fetchUserInfo(with authInfo: UserAuthInfoEntity) -> Single<UserInfoEntity?>

    /** Apple Authorization Code값 요청 */
    func fetchAppleAuthorizationCode() -> Single<String>
}
