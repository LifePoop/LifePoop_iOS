//
//  SelectableConfirmationCondition.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct SelectableConfirmationCondition {
    
    public enum DescriptionTextSize {
        case large
        case normal
        
        public var value: CGFloat {
            switch self {
            case .large:
                return 18
            case .normal:
                return 14
            }
        }
    }

    public enum SelectionType {
        case selectAll
        case essential
        case optional
    }
    
    public let descriptionText: String
    public let descriptionTextSize: DescriptionTextSize
    public let containsDetailView: Bool
    public let selectionType: SelectionType
    
    public init(
        descriptionText: String,
        descriptionTextSize: DescriptionTextSize,
        containsDetailView: Bool,
        selectionType: SelectionType
    ) {
        self.descriptionText = descriptionText
        self.descriptionTextSize = descriptionTextSize
        self.containsDetailView = containsDetailView
        self.selectionType = selectionType
    }
}

extension SelectableConfirmationCondition: Hashable { }