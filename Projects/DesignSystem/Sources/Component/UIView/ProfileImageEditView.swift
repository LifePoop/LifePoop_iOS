//
//  ProfileImageEditView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

public final class ProfileImageEditView: UIView {
    
    private lazy var profileImageView: CircularImageView = {
        let imageView = CircularImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var editImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.iconEdit.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(profileImageView)
        addSubview(editImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        editImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(profileImageView)
            make.width.height.equalTo(34)
        }
    }
    
    public func setProfileImageView(image: UIImage) {
        profileImageView.image = image
    }
}
