//
//  DefaultUserDefaultsRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import SharedUseCase
import Utils

public final class DefaultUserDefaultsRepository: UserDefaultsRepository {
    
    private let userDefaults = UserDefaults.standard
    
    public init() { }
    
    public func getValue<T: Codable>(for key: UserDefaultsKeys) -> Single<T?> {
        if let data = userDefaults.data(forKey: key.rawKey) {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return .just(value)
            } catch {
                return .error(UserDefaultsError.errorDetected(for: key, error: error))
            }
        }
        
        let value = userDefaults.object(forKey: key.rawKey) as? T
        return .just(value)
    }
    
    public func getValue<T: RawRepresentable>(for key: UserDefaultsKeys) -> Single<T?> where T.RawValue: Codable {
        if let rawValue = userDefaults.object(forKey: key.rawKey) as? T.RawValue, let value = T(rawValue: rawValue) {
            return .just(value)
        }
        return .just(nil)
    }
    
    public func updateValue<T: Codable>(for key: UserDefaultsKeys, with newValue: T) -> Completable {
        do {
            let data = try JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key.rawKey)
            return .empty()
        } catch {
            return .error(UserDefaultsError.errorDetected(for: key, error: error))
        }
    }
    
    public func updateValue<T: RawRepresentable>(
        for key: UserDefaultsKeys,
        with newValue: T
    ) -> Completable where T.RawValue: Codable {
        userDefaults.set(newValue.rawValue, forKey: key.rawKey)
        return .empty()
    }
    
    public func removeValue(for key: UserDefaultsKeys) -> Completable {
        userDefaults.removeObject(forKey: key.rawKey)
        return .empty()
    }
}
