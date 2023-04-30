//
//  DataMapper.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol DataMapper {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
