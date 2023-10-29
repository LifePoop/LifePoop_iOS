//
//  StoolLogCollectionViewDiffableDataSource.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import DesignSystem

import CoreEntity

final class StoolLogCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<StoolLogListSection, StoolLogItem> {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<StoolLogListSection, StoolLogItem>
    
    private let cellProvider = { (collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  stoolLogItem: StoolLogItem) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoolLogCollectionViewCell.identifier,
            for: indexPath
        ) as? StoolLogCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: stoolLogItem)
        
        if indexPath.section == .zero {
            cell.backgroundColor = .systemBackground
        }
        
        return cell
    }
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    func bindStoolLogHeaderView(with viewModel: StoolLogHeaderViewModel) {
        supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            print(indexPath.section)
            if indexPath.section == .zero {
                return self.dequeueCollectionReusableView(
                    for: collectionView,
                    kind: kind,
                    identifier: StoolLogHeaderView.identifier,
                    indexPath: indexPath,
                    configureAction: { (headerView: StoolLogHeaderView) in
                        headerView.bind(viewModel: viewModel)
                    }
                )
            } else {
                return self.dequeueCollectionReusableView(
                    for: collectionView,
                    kind: kind,
                    identifier: StoolLogDateHeaderView.identifier,
                    indexPath: indexPath,
                    configureAction: { (headerView: StoolLogDateHeaderView) in
                        headerView.setDate(from: indexPath.section)
                    }
                )
            }
        }
    }
    
    // MARK: - DiffableDataSource Methods
    
    func update(with stoolLogEntities: [StoolLogItem]) {
        var snapshot = Snapshot()
        for stoolLogListSection in StoolLogListSection.allCases {
            snapshot.appendSections([stoolLogListSection])
        }
        for stoolLogEntity in stoolLogEntities {
            snapshot.appendItems([stoolLogEntity], toSection: stoolLogEntity.section)
        }
        apply(snapshot, animatingDifferences: true)
    }
    
    func reapplyCurrentSnapshot() {
        var currentSnapshot = self.snapshot()
        apply(currentSnapshot, animatingDifferences: true)
    }
}
