//
//  UICollectionViewDataSource+dequeueCollectionReusableView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/10/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public extension UICollectionViewDataSource {
    func dequeueCollectionReusableView<T: UICollectionReusableView>(
        for collectionView: UICollectionView,
        kind: String,
        identifier: String,
        indexPath: IndexPath,
        configureAction: (T) -> Void) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else { return UICollectionReusableView() }
        configureAction(headerView)
        return headerView
    }
}
