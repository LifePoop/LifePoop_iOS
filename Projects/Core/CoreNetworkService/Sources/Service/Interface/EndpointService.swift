//
//  EndpointService.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxSwift

public protocol EndpointService {
    func fetchData<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Data>
    func fetchStatusCode<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Int>
    func fetchNetworkResult<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<NetworkResult>
}

public extension EndpointService {
    func fetchData(endpoint: TargetType) -> Single<Data> {
        fetchData(endpoint: endpoint, with: EmptyBody())
    }

    func fetchStatusCode(endpoint: TargetType) -> Single<Int> {
        fetchStatusCode(endpoint: endpoint, with: EmptyBody())
    }
    
    func fetchNetworkResult(endpoint: TargetType) -> Single<NetworkResult> {
        fetchNetworkResult(endpoint: endpoint, with: EmptyBody())
    }

}
