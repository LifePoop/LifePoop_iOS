//
//  Rx+decodeMap.swift
//  CoreExtension
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

import CoreError

public extension ObservableType where Element == Data {
    func decodeMap<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return map { data in
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decodeError
            }
            return decodedData
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    func decodeMap<T: Decodable>(_ type: T.Type) -> Single<T> {
        return asObservable().decodeMap(type).asSingle()
    }
}
