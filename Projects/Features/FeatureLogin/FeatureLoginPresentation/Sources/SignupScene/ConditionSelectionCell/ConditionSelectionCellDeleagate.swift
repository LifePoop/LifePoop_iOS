//
//  ConditionSelectionCellDeleagate.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

final class ConditionSelectionCollectionViewDelegate: NSObject {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        
        let horizontalInset: CGFloat = 16
        let cellWidth = collectionView.bounds.width - (horizontalInset * 2)
        let cellHeight: CGFloat = 22
        let bottomMargin: CGFloat = 13

        return .init(width: cellWidth, height: cellHeight + bottomMargin)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return .init(top: 17, left: 16, bottom: 17, right: 16)
    }
}


extension ConditionSelectionCollectionViewDelegate: UICollectionViewDelegate { }
extension ConditionSelectionCollectionViewDelegate: UICollectionViewDelegateFlowLayout { }
