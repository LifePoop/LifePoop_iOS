//
//  ProfileImageView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class ProfileImageView: CircularImageView {
    
    private let activeImage = ImageAsset.storyActive.original
    private let inactiveImage = ImageAsset.storyInactive.original
    
    public init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImage(by isActivated: Bool) {
        image = isActivated ? activeImage : inactiveImage
    }
}
