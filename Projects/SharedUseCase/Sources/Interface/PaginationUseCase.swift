//
//  PaginationUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import CoreEntity

public protocol PaginationUseCase {
    func finishLoading(_ paginationState: PaginationState) -> PaginationState
    func prepareNextPage(_ paginationState: PaginationState) -> PaginationState
    func resetToInitial(_ paginationState: PaginationState) -> PaginationState
}
