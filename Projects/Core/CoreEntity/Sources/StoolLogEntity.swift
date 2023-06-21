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
    public let didLog: Bool
    public let date: String?
    public let color: StoolColor
    public let shape: StoolShape
    public let size: StoolSize
}

extension StoolLogEntity: Hashable { }

extension StoolLogEntity {
    public static var dummyData: [StoolLogEntity] {
        return [
            StoolLogEntity(id: 0, didLog: true, date: "오후 11:41", color: .brown, shape: .soft, size: .small),
            StoolLogEntity(id: 1, didLog: true, date: "오후 11:42", color: .brown, shape: .good, size: .small),
            StoolLogEntity(id: 2, didLog: true, date: "오후 11:43", color: .brown, shape: .hard, size: .small),
            StoolLogEntity(id: 3, didLog: true, date: "오후 11:44", color: .black, shape: .soft, size: .small),
            StoolLogEntity(id: 4, didLog: true, date: "오후 11:45", color: .black, shape: .good, size: .small),
            StoolLogEntity(id: 5, didLog: true, date: "오후 11:46", color: .black, shape: .hard, size: .small),
            StoolLogEntity(id: 6, didLog: true, date: "오후 11:47", color: .pink, shape: .soft, size: .small),
            StoolLogEntity(id: 7, didLog: true, date: "오후 11:48", color: .pink, shape: .good, size: .small),
            StoolLogEntity(id: 8, didLog: true, date: "오후 11:49", color: .pink, shape: .hard, size: .small),
            StoolLogEntity(id: 9, didLog: true, date: "오후 11:50", color: .green, shape: .soft, size: .small),
            StoolLogEntity(id: 10, didLog: true, date: "오후 11:51", color: .green, shape: .good, size: .small),
            StoolLogEntity(id: 11, didLog: true, date: "오후 11:52", color: .green, shape: .hard, size: .small),
            StoolLogEntity(id: 12, didLog: true, date: "오후 11:53", color: .yellow, shape: .soft, size: .small),
            StoolLogEntity(id: 13, didLog: true, date: "오후 11:54", color: .yellow, shape: .good, size: .small),
            StoolLogEntity(id: 14, didLog: true, date: "오후 11:55", color: .yellow, shape: .hard, size: .small)
        ]
    }
}
