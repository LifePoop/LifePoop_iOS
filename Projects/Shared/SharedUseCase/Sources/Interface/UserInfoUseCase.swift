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

public protocol UserInfoUseCase: AnyObject {
    
    /** 기기에 저장된 사용자 정보 조회*/
    var userInfo: Observable<UserInfoEntity?> { get }
    /** 기존 사용자 인증 정보 업데이트(서버 동기화)*/
    func refreshAuthInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool>
    /** 기존 사용자 정보 업데이트(서버 동기화)*/
    func fetchUserInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool>
    /** 애플 탈퇴 요청*/
    func requestAccountWithdrawl(for loginType: LoginType) -> Observable<Bool>
}
