//
//  SelectCollectionViewDelegate.swift
//  FeatureStoolLogPresentation
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

final class SelectCollectionViewDelegate: NSObject,
                                          UICollectionViewDelegate,
                                          UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let margin = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? .zero
        let numberOfCells = CGFloat(collectionView.numberOfItems(inSection: 0))
        let sumOfMargins = margin*(numberOfCells-1)
        
        let cellWidth = (collectionView.bounds.width - sumOfMargins)/numberOfCells
        let cellHeight = collectionView.bounds.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
