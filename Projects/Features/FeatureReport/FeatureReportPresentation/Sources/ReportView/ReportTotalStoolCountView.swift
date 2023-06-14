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

import CoreEntity
import DesignSystem
import Utils

final class ReportTotalStoolCountView: UIView {
    
    private lazy var countDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(nickname: String, periodText: String, count: Int) {
        animatingCountDescription(nickname: nickname, periodText: periodText, count: count)
    }
    
    private func layoutUI() {
        addSubview(countDescriptionLabel)
        
        countDescriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Animating Methods

private extension ReportTotalStoolCountView {
    func animatingCountDescription(nickname: String, periodText: String, count: Int) {
        let prefixString = "최근 \(periodText) 내 \(nickname)님은 "
        let suffixString = " 변했어요"
        countDescriptionLabel.startCountingAnimation(upTo: count) { [weak self] currentCount in
            let countString = "\(currentCount)번"
            let fullString = "\(prefixString)\(countString)\(suffixString)"
            self?.countDescriptionLabel.text = fullString
            if let range = self?.countDescriptionLabel.rangeOfString(target: countString) {
                self?.countDescriptionLabel.applyFontAndColor(
                    font: .boldSystemFont(ofSize: 20),
                    color: ColorAsset.primary.color,
                    range: range
                )
            }
        }
    }
    
}
