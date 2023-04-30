//
//  CoreExampleDataMapper.swift
//  CoreDataMapper
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import CoreDTO
import CoreEntity

public struct CoreExampleDataMapper: DataMapper {
    public init() { }
    
    public func transform(_ coreDTO: CoreExampleDTO) -> CoreExampleEntity {
        return CoreExampleEntity(name: coreDTO.name, age: coreDTO.age)
    }
}
