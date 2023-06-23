//
//  StoolLogCollectionViewSectionLayout.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem

public final class StoolLogCollectionViewSectionLayout: CollectionViewSectionProvidable {
    
    public var headerLayoutHeight: CGFloat = .zero
    
    private lazy var headerLayoutSize: NSCollectionLayoutSize = {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(headerLayoutHeight)
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
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 24,
            leading: 24,
            bottom: 24,
            trailing: 24
        )
        return layoutGroup
    }()
    
    public lazy var layoutSection: NSCollectionLayoutSection = {
        let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
        let contentHeaderOffset: CGFloat = 16
        let interGroupSpacing: CGFloat = 16 - (layoutGroup.contentInsets.top + layoutGroup.contentInsets.bottom)
        
        sectionLayout.interGroupSpacing = interGroupSpacing
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(
            top: contentHeaderOffset,
            leading: .zero,
            bottom: .zero,
            trailing: .zero
        )
        sectionLayout.boundarySupplementaryItems = [headerItem]
        return sectionLayout
    }()
}

extension StoolLogCollectionViewSectionLayout {
    func setHeaderLayoutHeight(by isStoolLogEmpty: Bool) {
        let heightWithoutCheeringButtonView: CGFloat = 166
        let heightWithCheeringButtonView: CGFloat = 246
        headerLayoutHeight = isStoolLogEmpty ? heightWithoutCheeringButtonView : heightWithCheeringButtonView
    }
}
