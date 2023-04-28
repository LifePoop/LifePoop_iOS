//
//  DIContainer.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol DIContainer: AnyObject {
    var storage: [String: Any] { get set }
}

public extension DIContainer {
    func register<T>(service: T.Type, _ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        storage[key] = factory
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let factory = storage[key] as? () -> T else {
            fatalError("Dependency \(T.self) not resolved.")
        }
        return factory()
    }
}
