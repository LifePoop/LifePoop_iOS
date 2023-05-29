//
//  LoginError.swift
//  FeatureLoginRepository
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum LoginError: Error {
    case kakaoTalkLoginNotAvailable
    case authTokenNil
}
