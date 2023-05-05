//
//  ViewCell+identifier.swift
//  FeatureLoginRepository
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public protocol Identifiable { }

extension Identifiable {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Identifiable { }
extension UITableViewCell: Identifiable { }
extension UICollectionReusableView: Identifiable { }
extension UITableViewHeaderFooterView: Identifiable { }
