//
//  StoolLogHeaderView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class StoolLogHeaderView: UICollectionReusableView {
    
    private lazy var todayStoolLogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.text = "2022년 11월 19일의 변기록이에요"
        return label
    }()
    
    private lazy var cheeringButtonView = CheeringButtonView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Layout

private extension StoolLogHeaderView {
    func layoutUI() {
        addSubview(todayStoolLogLabel)
        addSubview(cheeringButtonView)
        
        todayStoolLogLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        cheeringButtonView.snp.makeConstraints { make in
            make.top.equalTo(todayStoolLogLabel.snp.bottom).offset(18)
            make.leading.trailing.equalTo(todayStoolLogLabel)
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
    }
}
