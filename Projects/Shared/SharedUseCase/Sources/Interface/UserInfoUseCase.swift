//
//  UserInfoUseCase.swift
//  SharedUseCase
//
//  Created by Lee, Joon Woo on 2023/10/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import RxSwift

public enum UserInfoError: Error {
    case refreshingTokenFailed
    case refreshingUserInfoFailed
}

public protocol UserInfoUseCase: AnyObject {
    
    /** 기기에 저장된 사용자 정보 조회*/
    var userInfo: Observable<UserInfoEntity?> { get }
    /** 기존 사용자 인증 정보 업데이트(서버 동기화)*/
    func refreshAuthInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool>
    /** 기존 사용자 정보 업데이트(서버 동기화)*/
    func fetchUserInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool>
    /** 로그아웃 요청 */
    func requestLogout() -> Observable<Void>
    /// 회원 탈퇴 요청
    ///
    /// 정상적으로 요청이 성공하면 true, 사용자가 탈퇴를 취소하면 false 값을 방출
    ///
    /// 예외의 경우에는 false가 아닌 error 이벤트가 방출되야 함
    func requestAccountWithdrawl(for loginType: LoginType) -> Observable<Bool>
}
