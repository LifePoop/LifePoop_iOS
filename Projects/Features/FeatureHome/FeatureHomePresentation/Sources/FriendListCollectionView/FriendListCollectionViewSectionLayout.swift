//
//  FriendListCollectionViewSectionLayout.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem

public final class FriendListCollectionViewSectionLayout: CollectionViewSectionProvidable {
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
            widthDimension: .absolute(50),
            heightDimension: .fractionalHeight(1)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitems: [layoutItem]
        )
        return layoutGroup
    }()

    public lazy var layoutSection: NSCollectionLayoutSection = {
        let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
        sectionLayout.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        sectionLayout.contentInsets = .init(top: 16, leading: 24, bottom: 16, trailing: 16)
        sectionLayout.interGroupSpacing = 14
        return sectionLayout
    }()
}
