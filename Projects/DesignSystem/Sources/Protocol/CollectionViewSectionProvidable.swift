//
//  CollectionViewSectionProvidable.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public protocol CollectionViewSectionProvidable {
    var layoutSection: NSCollectionLayoutSection { get }
}

extension CollectionViewSectionProvidable {
    public func sectionProvider(
        _ section: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        return layoutSection
    }
}
