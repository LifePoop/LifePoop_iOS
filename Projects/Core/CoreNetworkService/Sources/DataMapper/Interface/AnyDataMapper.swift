//
//  AnyDataMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

// MARK: Eraser Pattern for DataMapper
public struct AnyDataMapper<DTO, Entity>: DataMapper {
    private let _transform: (_: DTO) -> Entity
    
    public init<T: DataMapper>(_ mapper: T) where T.Input == DTO, T.Output == Entity {
        self._transform = mapper.transform
    }
    
    public func transform(_ dto: DTO) -> Entity {
        return _transform(dto)
    }
}
