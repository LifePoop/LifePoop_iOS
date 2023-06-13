//
//  ReportTotalColorView.swift
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

final class ReportTotalColorView: UIView {
    
    private let barView = StoolCountBarView(color: ColorAsset.pooBrown.color, barWidthPercentage: 1, count: 5)
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(barView)
        
        barView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
