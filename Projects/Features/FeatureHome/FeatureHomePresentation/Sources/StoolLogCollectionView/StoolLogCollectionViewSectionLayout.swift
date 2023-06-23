//
//  StoolLogCollectionViewSectionLayout.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem

final class StoolLogCollectionViewSectionLayout: CollectionViewSectionProvidable {
    
    private enum HeaderType {
        case includeCheeringButtonView
        case excludeCheeringButtonView
        
        var height: CGFloat {
            switch self {
            case .includeCheeringButtonView:
                return 246
            case .excludeCheeringButtonView:
                return 166
            }
        }
    }
    
    private let headerLayoutSize: NSCollectionLayoutSize
    
    init(shouldLayoutCheeringButton: Bool = false) {
        let headerType: HeaderType = shouldLayoutCheeringButton ?
            .includeCheeringButtonView : .excludeCheeringButtonView
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(headerType.height)
        )
        self.headerLayoutSize = headerLayoutSize
    }
    
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
