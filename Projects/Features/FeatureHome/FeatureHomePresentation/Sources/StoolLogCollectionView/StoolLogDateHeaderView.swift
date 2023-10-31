//
//  StoolLogDateHeaderView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/10/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem
import Utils

final class StoolLogDateHeaderView: UICollectionReusableView {
    private let separatorView = SeparatorView()
    
    private let todayStoolLogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorAsset.gray200.color
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todayStoolLogLabel.text = nil
    }
    
    func setDate(from dayIndex: Int) {
        let calendar = Calendar.current
        let now = Date()
        guard let currentDate = calendar.date(byAdding: .day, value: -dayIndex, to: now) else { return }
        let textString = LocalizableString.stoolDiaryFor(currentDate.koreanDateString)
        todayStoolLogLabel.text = textString
    }
}

// MARK: - UI Layout

private extension StoolLogDateHeaderView {
    func layoutUI() {
        addSubview(separatorView)
        addSubview(todayStoolLogLabel)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        todayStoolLogLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.equalTo(separatorView)
            make.bottom.equalToSuperview()
        }
    }
}
