//
//  DefaultUserDefaultsRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import SharedUseCase
import Utils

public final class DefaultUserDefaultsRepository: UserDefaultsRepository {
    
    private let userDefaults = UserDefaults.standard
    
    public init() { }
    
    public func getValue<T: Codable>(for key: UserDefaultsKeys) -> T? {
        if let data = userDefaults.data(forKey: key.rawKey) {
            let value = try? PropertyListDecoder().decode(T.self, from: data)
            return value
        }
        
        return userDefaults.object(forKey: key.rawKey) as? T
    }
    
    public func updateValue<T: Codable>(for key: UserDefaultsKeys, with newValue: T) {
        if let data = try? PropertyListEncoder().encode(newValue) {
            userDefaults.set(data, forKey: key.rawKey)
            return
        }
        
        userDefaults.setValue(newValue, forKey: key.rawKey)
    }
    
    public func removeValue(for key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawKey)
    }
}
