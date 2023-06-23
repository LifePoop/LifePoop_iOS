//
//  StoolLogEntity.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/04.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct StoolLogEntity {
    public let id: Int
    public let date: String?
    public let isSatisfied: Bool
    public let color: StoolColor
    public let shape: StoolShape
    public let size: StoolSize
    
    public init(
        id: Int,
        date: String?,
        isSatisfied: Bool,
        color: StoolColor,
        shape: StoolShape,
        size: StoolSize
    ) {
        self.id = id
        self.date = date
        self.isSatisfied = isSatisfied
        self.color = color
        self.shape = shape
        self.size = size
    }
}

extension StoolLogEntity: Hashable { }

extension StoolLogEntity {
    public static var dummyData: [StoolLogEntity] {
        return [
            StoolLogEntity(id: 0, date: "오후 11:41", isSatisfied: true, color: .brown, shape: .soft, size: .small),
            StoolLogEntity(id: 1, date: "오후 11:42", isSatisfied: false, color: .brown, shape: .good, size: .small),
            StoolLogEntity(id: 2, date: "오후 11:43", isSatisfied: true, color: .brown, shape: .hard, size: .small),
            StoolLogEntity(id: 3, date: "오후 11:44", isSatisfied: false, color: .black, shape: .soft, size: .small),
            StoolLogEntity(id: 4, date: "오후 11:45", isSatisfied: true, color: .black, shape: .good, size: .small),
            StoolLogEntity(id: 5, date: "오후 11:46", isSatisfied: true, color: .black, shape: .hard, size: .small),
            StoolLogEntity(id: 6, date: "오후 11:47", isSatisfied: true, color: .pink, shape: .soft, size: .small),
            StoolLogEntity(id: 7, date: "오후 11:48", isSatisfied: true, color: .pink, shape: .good, size: .small),
            StoolLogEntity(id: 8, date: "오후 11:49", isSatisfied: true, color: .pink, shape: .hard, size: .small),
            StoolLogEntity(id: 9, date: "오후 11:50", isSatisfied: true, color: .green, shape: .soft, size: .small),
            StoolLogEntity(id: 10, date: "오후 11:51", isSatisfied: true, color: .green, shape: .good, size: .small),
            StoolLogEntity(id: 11, date: "오후 11:52", isSatisfied: true, color: .green, shape: .hard, size: .small),
            StoolLogEntity(id: 12, date: "오후 11:53", isSatisfied: false, color: .yellow, shape: .soft, size: .small),
            StoolLogEntity(id: 13, date: "오후 11:54", isSatisfied: true, color: .yellow, shape: .good, size: .small),
            StoolLogEntity(id: 14, date: "오후 11:55", isSatisfied: false, color: .yellow, shape: .hard, size: .small)
        ]
    }
}
