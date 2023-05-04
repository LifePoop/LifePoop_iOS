//
//  StoolLogCollectionViewCompositionalLayout.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public protocol CollectionViewSectionProvider {
    func sectionProvider(_ section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

public final class StoolLogCollectionViewSectionLayout {
    
    public var collectionViewSize: CGSize = .zero
    private let headerHeight: CGFloat = 100
    
    private lazy var headerLayoutSize: NSCollectionLayoutSize = {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(collectionViewSize.width),
            heightDimension: .estimated(headerHeight)
        )
        return headerLayoutSize
    }()
    
    private lazy var headerItem: NSCollectionLayoutBoundarySupplementaryItem = {
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
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return layoutItem
    }()
    
    private lazy var layoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(collectionViewSize.width * 0.7),
//            heightDimension: .absolute((collectionViewSize.height - headerHeight) * 0.9)
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [layoutItem]
        )
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return layoutGroup
    }()
    
    private lazy var layoutSection: NSCollectionLayoutSection = {
        let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(
//            top: collectionViewSize.height * 0.05,
//            leading: .zero,
//            bottom: collectionViewSize.height * 0.1,
//            trailing: collectionViewSize.width * 0.05
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        sectionLayout.interGroupSpacing = 20
        sectionLayout.boundarySupplementaryItems = [headerItem]
        
        return sectionLayout
    }()
}

extension StoolLogCollectionViewSectionLayout: CollectionViewSectionProvider {
    public func sectionProvider(_ section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        return layoutSection
    }
}
