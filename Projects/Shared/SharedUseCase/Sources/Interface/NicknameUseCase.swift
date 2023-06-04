//
//  NicknameUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

public protocol NicknameUseCase {
    var nickname: BehaviorSubject<String?> { get }
    func updateNickname(to newNickname: String)
}
