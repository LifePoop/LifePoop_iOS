//
//  StoolLogCollectionViewSectionLayout.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class StoolLogCollectionViewSectionLayout: CollectionViewSectionProvidable {
    
    public init() { }
    
    private lazy var headerItem: NSCollectionLayoutBoundarySupplementaryItem = {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(246)
        )
        
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return headerItem
    }()
    
    private lazy var layoutItem: NSCollectionLayoutItem = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        return layoutItem
    }()
    
    private lazy var layoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [layoutItem]
        )
        return layoutGroup
    }()
    
    public lazy var layoutSection: NSCollectionLayoutSection = {
        let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
        sectionLayout.interGroupSpacing = -16
        sectionLayout.boundarySupplementaryItems = [headerItem]
        return sectionLayout
    }()
}
