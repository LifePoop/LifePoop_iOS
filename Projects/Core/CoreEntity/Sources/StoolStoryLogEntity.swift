//
//  StoolStoryLogEntity.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/25.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolStoryLogEntity {
    
    public let stoolLog: StoolLogEntity
    public let isCheeringUpAvailable: Bool
    
    public init(stoolLog: StoolLogEntity, isCheeringUpAvailable: Bool) {
        self.stoolLog = stoolLog
        self.isCheeringUpAvailable = isCheeringUpAvailable
    }
}
