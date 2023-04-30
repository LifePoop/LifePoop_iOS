//
//  CoreExampleDTO.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import Foundation

public struct CoreExampleDTO: Decodable {
    public let name: String
    public let age: Int
    
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
