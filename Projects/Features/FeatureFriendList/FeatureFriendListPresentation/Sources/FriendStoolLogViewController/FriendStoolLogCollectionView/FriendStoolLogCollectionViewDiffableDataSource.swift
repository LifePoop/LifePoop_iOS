//
//  FriendStoolLogCollectionViewDiffableDataSource.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/10/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import CoreEntity
import DesignSystem

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
    
    func configureHeaderView(with viewModel: FriendStoolLogHeaderViewModel) {
        supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FriendStoolLogHeaderView.identifier,
                for: indexPath
            ) as? FriendStoolLogHeaderView else { return UICollectionReusableView() }
            headerView.configureView(with: viewModel)
            return headerView
        }
    }
    
    // MARK: - DiffableDataSource Methods
    
    func update(with stoolLogItems: [StoolLogItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.today])
        snapshot.appendItems(stoolLogItems, toSection: .today)
        apply(snapshot, animatingDifferences: true)
    }
}
