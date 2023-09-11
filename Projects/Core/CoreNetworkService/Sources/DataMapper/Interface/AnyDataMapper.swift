//
//  AnyDataMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct AnyDataMapper<Input, Output>: DataMapper {
    private let _transform: (_: Input) throws -> Output

    public init<T: DataMapper>(_ mapper: T) where T.Input == Input, T.Output == Output {
        self._transform = mapper.transform
    }

    public func transform(_ input: Input) throws -> Output {
        return try _transform(input)
    }
}
