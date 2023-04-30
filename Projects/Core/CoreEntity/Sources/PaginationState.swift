//
//  PaginationState.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct PaginationState {
    private let startPage: Int
    private let countPerPage: Int
    private var currentPage: Int
    private var isLoading = false
    
    public var fetchParameters: (perPage: Int, currentPage: Int) {
        return (countPerPage, currentPage)
    }
    
    public var canLoad: Bool {
        return !isLoading
    }
    
    public init(startPage: Int = 1, countPerPage: Int = 10) {
        self.startPage = startPage
        self.countPerPage = countPerPage
        self.currentPage = startPage
    }
    
    public mutating func finishLoading() {
        isLoading = false
    }
    
    public mutating func resetToInitial() {
        currentPage = startPage
        isLoading = false
    }
    
    public mutating func prepareNextPage() {
        isLoading = true
        currentPage += 1
    }
}
