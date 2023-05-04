//
//  UICollectionViewFlowLayout+layoutHeight.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/02.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    public var layoutHeight: CGFloat {
        itemSize.height + sectionInset.top + sectionInset.bottom
    }
}
