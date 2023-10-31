//
//  StoryFeedCollectionViewDiffableDataSource.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import CoreEntity

public final class StoryFeedCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<StoryFeedSection, StoryFeedEntity> {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<StoryFeedSection, StoryFeedEntity>
    
    private let cellProvider = { (collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  friendEntity: StoryFeedEntity) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryFeedCollectionViewCell.identifier,
            for: indexPath
        ) as? StoryFeedCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: friendEntity)
        return cell
    }
    
    public init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    // MARK: - DiffableDataSource Methods
    
    public func update(friendEntities: [StoryFeedEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.friend])
        snapshot.appendItems(friendEntities)
        apply(snapshot, animatingDifferences: true)
    }
}
