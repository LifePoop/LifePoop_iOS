//
//  FriendStoolLogCollectionViewSectionLayout.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/10/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public final class FriendStoolLogCollectionViewSectionLayout: CollectionViewSectionProvidable {
    
    public init() { }
    
    private lazy var layoutItem: NSCollectionLayoutItem = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 24,
            bottom: .zero,
            trailing: 24
        )
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
        sectionLayout.interGroupSpacing = 16
        return sectionLayout
    }()
}
