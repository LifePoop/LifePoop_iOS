//
//  CheeringFriendProfileCharacterView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit


public final class CheeringFriendProfileCharacterView: UIView {
    
    private let insetBetweenImages: CGFloat = 6.0
    
    private let firstCheeringFriendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let secondCheeringFriendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override var intrinsicContentSize: CGSize {
        let firstImageHeight = firstCheeringFriendImageView.image?.size.height ?? .zero
        let secondImageHeight = secondCheeringFriendImageView.image?.size.height ?? .zero
        
        let firstImageWidth = firstCheeringFriendImageView.image?.size.width ?? .zero
        let secondImageWidth = secondCheeringFriendImageView.image?.size.width ?? .zero
        let imageInset: CGFloat = (secondImageWidth > .zero) ? insetBetweenImages : .zero
        
        let intrinsicHeight = max(firstImageWidth, secondImageWidth)
        let intrinsicWidth = firstImageWidth + secondImageWidth - imageInset
        
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    public init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Layout

private extension CheeringFriendProfileCharacterView {
    func layoutUI() {
        addSubview(firstCheeringFriendImageView)
        addSubview(secondCheeringFriendImageView)
        
        firstCheeringFriendImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        secondCheeringFriendImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(firstCheeringFriendImageView.snp.trailing).inset(insetBetweenImages)
        }
    }
}

// MARK: - Public Methods

public extension CheeringFriendProfileCharacterView {
    func setCheeringFriendProfileCharacter(firstImage: UIImage?, secondImage: UIImage? = nil) {
        firstCheeringFriendImageView.image = firstImage
        secondCheeringFriendImageView.image = secondImage
        invalidateIntrinsicContentSize()
    }
}
