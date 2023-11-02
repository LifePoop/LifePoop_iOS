//
//  UserProfileEditRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol UserProfileEditRepository {
    func editUserProfile(accessToken: String, userProfileEntity: UserProfileEntity) -> Completable
}
