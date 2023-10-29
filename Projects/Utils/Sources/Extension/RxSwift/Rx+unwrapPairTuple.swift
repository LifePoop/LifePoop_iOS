//
//  Rx+unwrapPairTuple.swift
//  Utils
//
//  Created by 김상혁 on 2023/10/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxCocoa
import RxSwift

public extension ObservableType {
    func unwrapPairTuple<T, U>() -> Observable<(T, U)> where Element == (T?, U?) {
        return self.flatMap { (firstElement, secondElement) -> Observable<(T, U)> in
            guard let unwrappedFirstElement = firstElement,
                  let unwrappedSecondElement = secondElement else {
                return .empty()
            }
            return .just((unwrappedFirstElement, unwrappedSecondElement))
        }
    }
}
