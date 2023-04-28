//
//  URLDataRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public protocol URLDataRepository {
    func fetchCachedData(from url: URL?) -> Single<Data>
}
