//
//  LifePoopButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class LifePoopButton: PaddingButton {
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private let title: String
    private var attributedTitle: NSAttributedString {
        NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.systemBackground,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
        )
    }
    
    public override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    public init(title: String) {
        self.title = title
        super.init(padding: Padding.custom(UIEdgeInsets(top: 17.5, left: .zero, bottom: 17.5, right: .zero)))
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = 12
        updateBackgroundColor()
        setAttributedTitle(attributedTitle, for: .normal)
        setTitleColor(.systemBackground, for: .normal)
        setTitleColor(.systemBackground, for: .disabled)
    }
    
    private func layoutUI() {
        addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateBackgroundColor() {
        if isEnabled {
            backgroundColor = isHighlighted ? ColorAsset.disabledBlue.color : ColorAsset.primary.color
        } else {
            backgroundColor = ColorAsset.disabledBlue.color
        }
    }
}

// MARK: - Public Methods

public extension LifePoopButton {
    func showLoadingIndicator() {
        isEnabled = false
        setAttributedTitle(nil, for: .normal)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        isEnabled = true
        setAttributedTitle(attributedTitle, for: .normal)
        loadingIndicator.stopAnimating()
    }
}
