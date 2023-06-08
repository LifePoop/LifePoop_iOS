//
//  GenderSelectionCollectionViewDelegate.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

final class GenderSelectionCollectionViewDelegate: NSObject {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {

        let margin: CGFloat = 7
        let cellWidth = (collectionView.bounds.width - margin * 2) / 3
        let cellHeight = collectionView.bounds.height

        return .init(width: cellWidth, height: cellHeight)
    }
}

extension GenderSelectionCollectionViewDelegate: UICollectionViewDelegate { }
extension GenderSelectionCollectionViewDelegate: UICollectionViewDelegateFlowLayout { }
