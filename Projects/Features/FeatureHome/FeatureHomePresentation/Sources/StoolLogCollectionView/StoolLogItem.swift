//
//  StoolLogItem.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/06/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity

struct StoolLogItem {
    
    private let id = UUID()
    
    enum ItemState {
        case stoolLog(StoolLogEntity)
        case empty
    }
    
    init(itemState: ItemState) {
        self.itemState = itemState
    }
    
    let itemState: ItemState
}

extension StoolLogItem: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
