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
    public let texture: StoolTexture
    public let size: StoolSize
}

extension StoolLogEntity: Hashable { }

extension StoolLogEntity {
    public static var dummyData: [StoolLogEntity] {
        return [
            StoolLogEntity(id: 0, didLog: false, date: "아직 변하지 않았어요", color: .brown, texture: .hard, size: .small),
            StoolLogEntity(id: 1, didLog: true, date: "오후 11:53", color: .green, texture: .hard, size: .small),
            StoolLogEntity(id: 2, didLog: true, date: "오후 11:54", color: .pink, texture: .hard, size: .small),
            StoolLogEntity(id: 3, didLog: true, date: "오후 11:55", color: .black, texture: .hard, size: .small),
            StoolLogEntity(id: 4, didLog: true, date: "오후 11:56", color: .brown, texture: .hard, size: .small),
            StoolLogEntity(id: 5, didLog: true, date: "오후 11:57", color: .green, texture: .hard, size: .small),
            StoolLogEntity(id: 6, didLog: true, date: "오후 11:58", color: .pink, texture: .hard, size: .small),
            StoolLogEntity(id: 7, didLog: true, date: "오후 11:59", color: .black, texture: .hard, size: .small)
        ]
    }
}

public enum StoolColor {
    case brown
    case black
    case pink
    case green
    case yellow
}

public enum StoolTexture {
    case soft
    case medium
    case hard
}

public enum StoolSize {
    case small
    case medium
    case large
}
