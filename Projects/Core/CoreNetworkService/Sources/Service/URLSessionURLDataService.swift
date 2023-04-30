//
//  URLSessionURLDataService.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public final class URLSessionURLDataService: URLDataService {
    
    public static let shared = URLSessionURLDataService()
    
    private init() {}
    
    public func fetchData(from url: URL) -> Single<Data> {
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.failure(NetworkError.errorDetected(error: error)))
                } else if let data = data {
                    single(.success(data))
                } else {
                    single(.failure(NetworkError.invalidResponseData))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
