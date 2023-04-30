//
//  MemoryCacheStorage.swift
//  CoreStorageService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public final class NSCacheMemoryCacheStorage: MemoryCacheStorage {
    
    public static let shared = NSCacheMemoryCacheStorage()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() { }
   
    public func lookUpData(by key: String) -> Data? {
        let cachedData = cache.object(forKey: key as NSString)
        return cachedData as Data?
    }
    
    public func storeData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
    }
}
