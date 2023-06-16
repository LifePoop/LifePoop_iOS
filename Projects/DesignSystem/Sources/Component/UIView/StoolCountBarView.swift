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
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var barStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [barView, countLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let barWidthPercentage: CGFloat
    
    public init(color: UIColor, barWidthPercentage: CGFloat, count: Int) {
        self.barWidthPercentage = barWidthPercentage
        super.init(frame: .zero)
        barView.backgroundColor = color
        countLabel.text = "\(count)번"
        layoutUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(barStackView)
        
//        barStackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        barStackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(barWidthPercentage)
        }
    }
}
