//
//  Rx+mapToVoid.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/11/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {

    func mapToVoid() -> Single<Void> {
        return map { _ in }
    }
}
