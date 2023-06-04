//
//  LoginTypeUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol LoginTypeUseCase {
    var loginType: BehaviorSubject<LoginType?> { get }
    func updateLoginType(to newLoginType: LoginType)
}
