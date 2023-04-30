//
//  Rx+unwrapData.swift
//  CoreExtension
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreComponent
import CoreError

public extension ObservableType where Element == NetworkResult {
    func unwrapData() -> Observable<Data> {
        return flatMap { networkResult -> Observable<Data> in
            guard let data = networkResult.data else {
                return .error(NetworkError.invalidResponseData)
            }
            return .just(data)
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == NetworkResult {
    func unwrapData() -> Single<Data> {
        return asObservable().unwrapData().asSingle()
    }
}
