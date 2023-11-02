//
//  UserProfileEditUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol UserProfileEditUseCase {
    func editUserProfile(userProfileEntity: UserProfileEntity) -> Completable
}
