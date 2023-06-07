//
//  UserInfoUseCase.swift
//  SharedUseCase
//
//  Created by Lee, Joon Woo on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol UserInfoUseCase {

    var userInfo: Observable<UserInfoEntity?> { get }
    
    func clearUserAuthInfoIfNeeded() -> Completable
}
