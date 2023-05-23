//
//  LifePoopBackBarButtonItem.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class LifePoopBackBarButtonItem: UIBarButtonItem {
    
    public override init() {
        super.init()
        title = ""
        image = ImageAsset.expandLeft.original
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
