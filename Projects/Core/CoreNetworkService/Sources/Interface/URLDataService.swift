//
//  URLDataService.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public protocol URLDataService {
    func fetchData(from url: URL) -> Single<Data>
}
