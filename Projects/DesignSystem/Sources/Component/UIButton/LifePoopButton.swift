//
//  LifePoopButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public class LifePoopButton: PaddingButton {
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
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
    
    private var storedTitle: NSAttributedString?
    
    public init() {
        super.init(padding: Padding.custom(UIEdgeInsets(top: 17.5, left: .zero, bottom: 17.5, right: .zero)))
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        setAttributedTitle(title?.nsAttributedString(fontSize: 16, weight: .bold, color: .systemBackground), for: state)
    }
    
    private func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = 12
        updateBackgroundColor()
    }
    
    private func layoutUI() {
        addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Supporting Methods

private extension LifePoopButton {
    func updateBackgroundColor() {
        if isEnabled {
            backgroundColor = isHighlighted ? ColorAsset.disabledBlue.color : ColorAsset.primary.color
        } else {
            backgroundColor = ColorAsset.disabledBlue.color
        }
    }
    
    func storeCurrentTitle() {
        storedTitle = attributedTitle(for: .disabled)
    }
    
    func restoreTitle() {
        setAttributedTitle(storedTitle, for: .disabled)
        setAttributedTitle(storedTitle, for: .normal)
    }
    
    func removeTitle() {
        for state: UIControl.State in [.normal, .selected, .highlighted, .disabled] {
            setTitle(nil, for: state)
            setAttributedTitle(nil, for: state)
        }
    }
}

// MARK: - Public Methods

public extension LifePoopButton {
    func showLoadingIndicator() {
        storeCurrentTitle()
        removeTitle()
        isEnabled = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        restoreTitle()
        isEnabled = true
        loadingIndicator.stopAnimating()
    }
}
