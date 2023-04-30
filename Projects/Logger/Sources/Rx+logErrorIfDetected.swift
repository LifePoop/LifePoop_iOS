//
//  Rx+logErrorIfDetected.swift
//  Logger
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import OSLog

import RxSwift

public extension ObservableType {
    func logErrorIfDetected() -> Observable<Element> {
        return self.do(onError: { error in
            let errorMessage = error.localizedDescription
            let errorCategory = (error as? OSLoggable)?.category ?? .default
            Logger.log(message: errorMessage, category: errorCategory, type: .error)
        })
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func logErrorIfDetected() -> Single<Element> {
        return self.asObservable().logErrorIfDetected().asSingle()
    }
}

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    func logErrorIfDetected() -> Completable {
        return self.asObservable().logErrorIfDetected().asCompletable()
    }
}
