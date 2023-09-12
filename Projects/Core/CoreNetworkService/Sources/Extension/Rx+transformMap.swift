//
//  Rx+transformMap.swift
//  CoreExtension
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

// MARK: - For Non-Sequence Element

public extension ObservableType {
    func transformMap<T: DataMapper>(_ mapper: T) -> Observable<T.Output> where Element == T.Input {
        return map { element in
            return try mapper.transform(element)
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func transformMap<T: DataMapper>(_ mapper: T) -> Single<T.Output> where Element == T.Input {
        return asObservable().transformMap(mapper).asSingle()
    }
}

// MARK: - For Sequence Element

public extension ObservableType where Element: Sequence {
    func transformMap<T: DataMapper>(_ mapper: T) -> Observable<[T.Output]> where Element.Element == T.Input {
        return map { sequenceElement in
            return try sequenceElement.map { try mapper.transform($0) }
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func transformMap<T: DataMapper>(_ mapper: T) -> Single<[T.Output]> where Element == [T.Input] {
        return asObservable().transformMap(mapper).asSingle()
    }
}
