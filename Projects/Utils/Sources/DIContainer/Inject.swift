//
//  Inject.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Inject<Service, Container: DIContainer> {
    private let component: Service

    public init(_ container: Container) {
        self.component = container.resolve()
    }

    public var wrappedValue: Service {
        return component
    }
}
