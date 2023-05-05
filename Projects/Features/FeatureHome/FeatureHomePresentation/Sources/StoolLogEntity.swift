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
