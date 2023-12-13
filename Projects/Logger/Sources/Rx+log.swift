//
//  Rx+log.swift
//  Logger
//
//  Created by Lee, Joon Woo on 2023/11/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import OSLog

import RxSwift

public extension ObservableType {
    func log(message: String, category: OSLog.LogCategory, printElement: Bool = false) -> Observable<Element> {
        return self.logErrorIfDetected(category: category, type: .error)
            .do(onNext: { element in
            let message = printElement ? "\(message)\nvalue:\(element)" : message
            Logger.log(message: message, category: category, type: .debug)
        })
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func log(message: String, category: OSLog.LogCategory, printElement: Bool = false) -> Single<Element> {
        return self.asObservable()
            .log(message: message, category: category, printElement: printElement)
            .asSingle()
    }
}

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    func log(message: String, category: OSLog.LogCategory, printElement: Bool = false) -> Completable {
        return self.asObservable()
            .log(message: message, category: category, printElement: printElement)
            .asCompletable()
    }
}
