//
//  NicknameUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol NicknameUseCase {
    var nickname: Observable<String?> { get }
    func updateNickname(to newNickname: String) -> Completable
    func checkNicknameValidation(for input: String) -> Observable<NicknameTextInput>
}
