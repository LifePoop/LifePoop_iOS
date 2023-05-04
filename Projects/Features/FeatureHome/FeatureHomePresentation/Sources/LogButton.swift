//
//  LogButton.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class LogButton: UIButton {
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension LogButton {
    func configureUI() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.contentInsets = .init(top: 17.5, leading: 17.5, bottom: 17.5, trailing: 17.5)
        config.baseBackgroundColor = UIColor(red: .zero, green: 102/255, blue: 1, alpha: 1.0)
        var attributedTitleText = AttributedString("변 기록하기")
        attributedTitleText.font = .systemFont(ofSize: 16, weight: .bold)
        config.attributedTitle = attributedTitleText
        
        configuration = config
    }
}
