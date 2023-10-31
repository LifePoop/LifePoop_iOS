//
//  FriendStoolLogCollectionViewDiffableDataSource.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/10/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import DesignSystem

import CoreEntity

final class FriendStoolLogCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<StoolLogListSection, StoolLogItem> {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<StoolLogListSection, StoolLogItem>
    
    private let cellProvider = { (collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  stoolLogItem: StoolLogItem) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendStoolLogCollectionViewCell.identifier,
            for: indexPath
        ) as? FriendStoolLogCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: stoolLogItem)
        return cell
    }
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    // MARK: - DiffableDataSource Methods
    
    func update(with stoolLogItems: [StoolLogItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.today])
        snapshot.appendItems(stoolLogItems)
        apply(snapshot, animatingDifferences: true)
    }
}
