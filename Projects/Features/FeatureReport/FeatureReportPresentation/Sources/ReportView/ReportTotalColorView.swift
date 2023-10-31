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

import CoreEntity
import DesignSystem
import Utils

final class ReportTotalColorView: UIView {
    
    private var colorBars: [StoolCountBarView] = []
    
    private let barViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColorBars(with stoolColorReports: [StoolColorReport]) {
        clearColorBars()
        stoolColorReports.forEach {
            updateColorBar(
                color: $0.color.color,
                count: $0.count,
                barWidthRatio: $0.barWidthRatio
            )
        }
    }
    
    private func layoutUI() {
        addSubview(barViewStackView)
        
        barViewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private extension ReportTotalColorView {
    func updateColorBar(color: UIColor, count: Int, barWidthRatio: Double) {
        let barView = StoolCountBarView(
            color: color,
            count: count,
            barWidthRatio: barWidthRatio
        )
        barViewStackView.addArrangedSubview(barView)
        colorBars.append(barView)
    }
    
    func clearColorBars() {
        colorBars.forEach { $0.removeFromSuperview() }
        colorBars.removeAll()
    }
}
