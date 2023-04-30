//
//  Rx+asCompletableForStatusCode.swift
//  CoreExtension
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait, Element == Int {
    func asCompletableForStatusCode(expected: Int) -> Completable {
        return self.asObservable().flatMap { result -> Completable in
            if result == expected {
                return Completable.empty()
            } else {
                return Completable.error(NetworkError.invalidStatusCode(code: result))
            }
        }.asCompletable()
    }
}
