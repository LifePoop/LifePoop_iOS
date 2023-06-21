//
//  StoolLogCollectionViewDiffableDataSource.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import CoreEntity

public final class StoolLogCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<StoolLogListSection, StoolLogEntity> {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<StoolLogListSection, StoolLogEntity>
    
    private let cellProvider = { (collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  stoolLogEntity: StoolLogEntity) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoolLogCollectionViewCell.identifier,
            for: indexPath
        ) as? StoolLogCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: stoolLogEntity)
        return cell
    }
    
    public init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    func bindStoolLogHeaderView(with viewModel: StoolLogHeaderViewModel) {
        supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: StoolLogHeaderView.identifier,
                for: indexPath
            ) as? StoolLogHeaderView else { return UICollectionReusableView() }
            headerView.bind(viewModel: viewModel)
            return headerView
        }
    }
    
    // MARK: - DiffableDataSource Methods
    
    func update(with stoolLogEntities: [StoolLogEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.log])
        snapshot.appendItems(stoolLogEntities)
        apply(snapshot, animatingDifferences: true)
    }
}
