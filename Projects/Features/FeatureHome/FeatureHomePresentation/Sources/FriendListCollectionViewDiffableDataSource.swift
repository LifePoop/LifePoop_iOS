//
//  FriendListCollectionViewDiffableDataSource.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class FriendListCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<FriendListSection, FriendEntity> {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FriendListSection, FriendEntity>
    
    private let cellProvider = { (collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  friendEntity: FriendEntity) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendListCollectionViewCell.identifier,
            for: indexPath
        ) as? FriendListCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: friendEntity)
        return cell
    }
    
    public init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    // MARK: - DiffableDataSource Methods
    
    public func update(with friendEntities: [FriendEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.friend])
        snapshot.appendItems(friendEntities)
        apply(snapshot, animatingDifferences: true)
    }
}
