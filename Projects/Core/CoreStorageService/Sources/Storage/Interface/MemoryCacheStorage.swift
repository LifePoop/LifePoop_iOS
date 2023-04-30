//
//  MemoryCacheStorage.swift
//  CoreStorageService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol MemoryCacheStorage {
    func lookUpData(by key: String) -> Data?
    func storeData(_ data: Data, forKey key: String)
}
