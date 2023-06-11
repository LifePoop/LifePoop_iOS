//
//  SelectableConfirmationCondition.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct AgreementCondition {
    
    public enum DescriptionTextSize {
        case large
        case normal
        
        public var value: CGFloat {
            switch self {
            case .large:
                return 20
            case .normal:
                return 14
            }
        }
    }

    public enum SelectionType {
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
<<<<<<< HEAD:Projects/Core/CoreEntity/Sources/AgreementCondition.swift
        containsDetailView: Bool = false,
        selectionType: SelectionType = .optional
=======
        containsDetailView: Bool,
        selectionType: SelectionType
>>>>>>> 58-FeatureReport:Projects/Core/CoreEntity/Sources/SelectableConfirmationCondition.swift
    ) {
        self.descriptionText = descriptionText
        self.descriptionTextSize = descriptionTextSize
        self.containsDetailView = containsDetailView
        self.selectionType = selectionType
    }
}

extension AgreementCondition: Hashable { }
