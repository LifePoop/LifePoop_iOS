//
//  StoolLogItem.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/09/18.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolLogItem {
    
    private let id = UUID()
    
    public enum ItemState {
        case stoolLog(StoolLogEntity)
        case empty
    }
    
    public let itemState: ItemState
    
    public init(itemState: ItemState) {
        self.itemState = itemState
    }
}

extension StoolLogItem: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
