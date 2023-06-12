//
//  ReportTotalStoolCountView.swift
//  FeatureReportPresentation
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class ReportTotalStoolCountView: UIView {
    
    private lazy var countDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 1개월 내 김솝트님은 N번 변했어요"
        return label
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
        addSubview(countDescriptionLabel)
        
        countDescriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
