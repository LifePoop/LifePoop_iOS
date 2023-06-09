//
//  StoolCountBarView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

public final class StoolCountBarView: UIView {
    
    private let barView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let animatingDuration: CGFloat = 0.75
    private let barViewCountLabelOffset: CGFloat = 10
    private let barWidthPercentage: CGFloat
    private let countLabelMaxWidth: CGFloat
    
    private var timer: DispatchSourceTimer?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        expandBarViewWithAnimation()
    }
    
    public init(color: UIColor, count: Int, barWidthRatio: CGFloat) {
        barView.backgroundColor = color
        countLabel.text = DesignSystemStrings.count(count)
        self.countLabelMaxWidth = countLabel.intrinsicContentSize.width
        self.barWidthPercentage = barWidthRatio
        super.init(frame: .zero)
        layoutUI()
        startCountLabelAnimating(upTo: count)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(barView)
        addSubview(countLabel)
        
        barView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalTo(0)
            make.trailing.equalTo(countLabel.snp.leading).offset(-barViewCountLabelOffset)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Animating Methods

private extension StoolCountBarView {
    func startCountLabelAnimating(upTo count: Int) {
        countLabel.startCountingAnimation(upTo: count) { [weak self] animatingCount in
            self?.countLabel.text = "\(animatingCount)번"
        }
    }
    
    func expandBarViewWithAnimation() {
        UIView.animate(withDuration: animatingDuration) {
            self.barView.snp.updateConstraints { make in
                let availableWidthSpace = self.frame.width - self.countLabelMaxWidth - self.barViewCountLabelOffset
                make.width.equalTo(availableWidthSpace * self.barWidthPercentage)
            }
            self.layoutIfNeeded()
        }
    }
}
