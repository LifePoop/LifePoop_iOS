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
    
    private var nickname: String = "사용자" {
        didSet {
            updateCountDescription()
        }
    }
    private var periodText: String = "" {
        didSet {
            updateCountDescription()
        }
    }
    private var count: Int = 0 {
        didSet {
            updateCountDescription()
        }
    }
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(nickname: String) {
        self.nickname = nickname
    }
    
    func update(periodText: String, count: Int) {
        self.periodText = periodText
        self.count = count
    }
    
    private func updateCountDescription() {
        let attributedString = NSMutableAttributedString(
            string: "최근 \(periodText) 내 \(nickname)님은 ",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
        
        let countString = NSAttributedString(string: "\(count)번 ", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: ColorAsset.primary.color
        ])
        
        attributedString.append(countString)
        attributedString.append(NSAttributedString(string: "변했어요"))
        
        countDescriptionLabel.attributedText = attributedString
    }
    
    private func layoutUI() {
        addSubview(countDescriptionLabel)
        
        countDescriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
