//
//  IndexSelectable.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public protocol IndexSelectable: AnyObject {
    var isSelected: Bool { get set }
    var index: Int { get }
}

public extension IndexSelectable {
    func toggleSelection(isSelected: Bool) {
        self.isSelected = isSelected
    }
}

public extension Array where Element: IndexSelectable {
    func selectButtonOnly(at targetIndex: Int) {
        for (index, button) in enumerated() {
            button.toggleSelection(isSelected: index == targetIndex)
        }
    }
}
