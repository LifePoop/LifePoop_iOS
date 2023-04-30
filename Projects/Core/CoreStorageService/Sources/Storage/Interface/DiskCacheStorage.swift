//
//  DiskCacheStorage.swift
//  CoreStorageService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public protocol DiskCacheStorage {
    func lookUpData(by key: String) -> Single<Data>
    func storeData(_ data: Data, forKey key: String)
}
