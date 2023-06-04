//
//  UserDefaultsRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol UserDefaultsRepository {
    func getValue<T: Codable>(for key: UserDefaultsKeys) -> T?
    func getValue<T: RawRepresentable>(for key: UserDefaultsKeys) -> T? where T.RawValue: Codable
    func updateValue<T: Codable>(for key: UserDefaultsKeys, with newValue: T)
    func updateValue<T: RawRepresentable>(for key: UserDefaultsKeys, with newValue: T) where T.RawValue: Codable
    func removeValue(for key: UserDefaultsKeys)
}
