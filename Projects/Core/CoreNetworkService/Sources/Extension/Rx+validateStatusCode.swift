//
//  Rx+validateStatusCode.swift
//  CoreExtension
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public extension ObservableType where Element == NetworkResult {
    func validateStatusCode() -> Observable<Element> {
        return self.flatMap { networkResult -> Observable<Element> in
            guard 200...299 ~= networkResult.statusCode else {
                return .error(NetworkError.invalidStatusCode(code: networkResult.statusCode))
            }
            return .just(networkResult)
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == NetworkResult {
    func validateStatusCode() -> Single<Element> {
        return asObservable().validateStatusCode().asSingle()
    }
}
