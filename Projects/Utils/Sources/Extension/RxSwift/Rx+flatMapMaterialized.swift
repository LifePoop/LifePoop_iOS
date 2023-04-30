//
//  Rx+flatMapMaterialized.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

public extension ObservableType {
    func flatMapMaterialized<T>(_ selector: @escaping (Element) -> Observable<T>) -> Observable<Event<T>> {
        return self.flatMap {
            selector($0).materialize()
        }
    }
    
    func flatMapLatestMaterialized<T>(_ selector: @escaping (Element) -> Observable<T>) -> Observable<Event<T>> {
        return self.flatMapLatest {
            selector($0).materialize()
        }
    }
    
    func flatMapFirstMaterialized<T>(_ selector: @escaping (Element) -> Observable<T>) -> Observable<Event<T>> {
        return self.flatMapFirst {
            selector($0).materialize()
        }
    }
}
