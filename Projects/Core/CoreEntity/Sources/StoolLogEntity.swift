//
//  StoolLogEntity.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/04.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct StoolLogEntity {
    public var postID: Int?
    public let date: Date
    public let isSatisfied: Bool
    public let color: StoolColor
    public let shape: StoolShape
    public let size: StoolSize
    
    public init(
        postID: Int? = nil,
        date: Date,
        isSatisfied: Bool,
        color: StoolColor,
        shape: StoolShape,
        size: StoolSize
    ) {
        self.date = date
        self.isSatisfied = isSatisfied
        self.color = color
        self.shape = shape
        self.size = size
    }
    
    public init(postID: Int?, stoolLogEntity: StoolLogEntity) {
        self.postID = postID
        self.date = stoolLogEntity.date
        self.isSatisfied = stoolLogEntity.isSatisfied
        self.color = stoolLogEntity.color
        self.shape = stoolLogEntity.shape
        self.size = stoolLogEntity.size
    }
}

extension StoolLogEntity: Hashable { }

extension StoolLogEntity {
    public static var dummyData: [StoolLogEntity] {
        return [
            StoolLogEntity(date: Date(), isSatisfied: true, color: .brown, shape: .soft, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: false, color: .brown, shape: .good, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .brown, shape: .hard, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: false, color: .black, shape: .soft, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .black, shape: .good, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .black, shape: .hard, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .pink, shape: .soft, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .pink, shape: .good, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .pink, shape: .hard, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .green, shape: .soft, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .green, shape: .good, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .green, shape: .hard, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: false, color: .yellow, shape: .soft, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: true, color: .yellow, shape: .good, size: .small),
            StoolLogEntity(date: Date(), isSatisfied: false, color: .yellow, shape: .hard, size: .small)
        ]
    }
}
