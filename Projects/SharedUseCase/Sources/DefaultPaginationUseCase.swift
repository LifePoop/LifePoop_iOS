//
//  DefaultPaginationUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import CoreEntity
import Logger
import Utils

public final class DefaultPaginationUseCase: PaginationUseCase {
    public func finishLoading(_ paginationState: PaginationState) -> PaginationState {
        var newPaginationState = paginationState
        newPaginationState.finishLoading()
        return newPaginationState
    }
    
    public func prepareNextPage(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.prepareNextPage()
        return newState
    }
    
    public func resetToInitial(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.resetToInitial()
        return newState
    }
}
