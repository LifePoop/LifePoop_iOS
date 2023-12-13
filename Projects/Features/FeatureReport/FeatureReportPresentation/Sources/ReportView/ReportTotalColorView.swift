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
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.noStoolLogForPeriod
        label.textColor = .darkGray
        return label
    }()
    
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
        emptyLabel.isHidden = !stoolColorReports.isEmpty
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
        addSubview(emptyLabel)
        
        barViewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
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
