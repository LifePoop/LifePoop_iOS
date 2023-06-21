//
//  LifePoopAlertView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public class LifePoopAlertView: UIControl {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = .zero
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.title
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private (set)lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = type.subTitle
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = ColorAsset.gray800.color
        return label
    }()
    
    public lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var attributedTitleText = AttributedString(type.cancelButtonTitle)
        attributedTitleText.font = .systemFont(ofSize: 16, weight: .semibold)
        configuration.attributedTitle = attributedTitleText
        configuration.cornerStyle = .medium
        configuration.baseForegroundColor = ColorAsset.gray800.color
        configuration.baseBackgroundColor = ColorAsset.gray200.color
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16.5, leading: 21, bottom: 16.5, trailing: 21)
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    public lazy var confirmButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var attributedTitleText = AttributedString(type.confirmButtonTitle)
        attributedTitleText.font = .systemFont(ofSize: 16, weight: .semibold)
        configuration.attributedTitle = attributedTitleText
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = ColorAsset.primary.color
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16.5, leading: 21, bottom: 16.5, trailing: 21)
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private (set)lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let type: LifePoopAlertViewType
    
    public init(type: LifePoopAlertViewType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(in parentView: UIView) {
        addViews(in: parentView)
        fadeIn()
    }
    
    public func dismiss() {
        let removeViews: (Bool) -> Void = { _ in
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
        fadeOut(completion: removeViews)
    }
    
    public func moveUp(to value: CGFloat) {
        frame.origin.y -= value
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
}

// MARK: - Supporting Methods

private extension LifePoopAlertView {
    func addViews(in parentView: UIView) {
        parentView.addSubview(backgroundView)
        backgroundView.addSubview(self)
        backgroundView.frame = parentView.bounds
        
        snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(titleLabel).offset(-32)
            make.bottom.equalTo(buttonStackView).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 1
            self.alpha = 1
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = .zero
            self.alpha = .zero
        }, completion: completion)
    }
}

// MARK: - UI Configuration

private extension LifePoopAlertView {
    func configureUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}

// MARK: - UI Layout

private extension LifePoopAlertView {
    func layoutUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(buttonStackView)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
