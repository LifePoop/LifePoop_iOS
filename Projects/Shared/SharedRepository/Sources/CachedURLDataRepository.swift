//
//  CachedURLDataRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import CoreStorageService
import Utils

public final class CachedURLDataRepository: URLDataRepository {
    
    @Inject(CoreDIContainer.shared) private var memoryCacheStorage: MemoryCacheStorage
    @Inject(CoreDIContainer.shared) private var diskCacheStorage: DiskCacheStorage
    @Inject(CoreDIContainer.shared) private var urlDataService: URLDataService
    
    public func fetchCachedData(from url: URL?) -> Single<Data> {
        guard let url = url else {
            return Single.error(NetworkError.invalidURL)
        }
        
        let dataName = url.lastPathComponent
        
        return fetchFromMemoryCache(dataName: dataName)
            .catch { [weak self] error in
                guard let self = self else { return .error(FileSystemError.objectDeallocated) }
                return self.fetchFromDiskCache(dataName: dataName)
            }
            .catch { [weak self] error in
                guard let self = self else { return .error(FileSystemError.objectDeallocated) }
                return self.fetchFromRemoteAndCache(from: url, dataName: dataName)
            }
    }
}

// MARK: - Supporting Methods

private extension CachedURLDataRepository {
    func fetchFromMemoryCache(dataName: String) -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FileSystemError.objectDeallocated))
                return Disposables.create()
            }
            
            if let data = self.memoryCacheStorage.lookUpData(by: dataName) {
                single(.success(data))
            } else {
                single(.failure(FileSystemError.dataNotFound))
            }
            return Disposables.create()
        }
    }
    
    func fetchFromDiskCache(dataName: String) -> Single<Data> {
        return diskCacheStorage
            .lookUpData(by: dataName)
            .do(onSuccess: { [weak self] data in
                self?.memoryCacheStorage.storeData(data, forKey: dataName)
            })
    }
    
    func fetchFromRemoteAndCache(from url: URL, dataName: String) -> Single<Data> {
        return urlDataService.fetchData(from: url)
            .do(onSuccess: { [weak self] data in
                self?.memoryCacheStorage.storeData(data, forKey: dataName)
                self?.diskCacheStorage.storeData(data, forKey: dataName)
            })
    }
}
