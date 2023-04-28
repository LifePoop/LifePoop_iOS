//
//  Rx+flatMapCompletableMaterialized.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

public extension ObservableType {
    func flatMapCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMap {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
    
    func flatMapLatestCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMapLatest {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
    
    func flatMapFirstCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMapFirst {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
}
