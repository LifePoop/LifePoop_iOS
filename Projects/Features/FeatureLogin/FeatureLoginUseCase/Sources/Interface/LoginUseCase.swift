//
//  LoginUseCase.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity

public enum LoginResult {
    case success(authInfo: UserAuthInfoEntity)
    case failure(loginError: LoginError)
}

public protocol LoginUseCase {

    /** 앱 설치 후 최초 기동 시에 기존에 저장된 사용자 인증 정보 초기화*/
    func clearUserAuthInfoIfLaunchedFirstly() -> Completable
    /** 현재 로컬 기기에 저장된 사용자 인증 정보로 자동 로그인 처리 요청 */
    func requestAutoLoginWithExistingUserInfo() -> Observable<Bool>
    /** OAuth 토큰 정보로 Lifepoo Access Token, Refresh Token 획득 및 로그인 처리 요청 */
    func requestLogin(with userInfo: OAuthTokenInfo) -> Observable<Bool>
    /** 소셜 로그인(Apple, Kakao) OAuth Access Token 요청*/
    func fetchOAuthAccessToken(for loginType: LoginType) -> Observable<OAuthTokenInfo?>
}
