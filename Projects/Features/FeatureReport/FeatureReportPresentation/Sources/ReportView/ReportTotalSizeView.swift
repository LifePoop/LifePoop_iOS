//
//  ReportTotalSizeView.swift
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

final class ReportTotalSizeView: UIView {
    
    private let tableImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.reportSizeTable.original)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let softStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallSoftBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let goodStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallGoodBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let hardStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallHardBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let largeTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.large
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let mediumTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.medium
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let smallTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.small
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let largeSoftCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let largeGoodCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let largeHardCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let mediumSoftCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let mediumGoodCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let mediumHardCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let smallSoftCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let smallGoodCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let smallHardCountTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
    
    private func layoutUI() {
        addSubview(tableImageView)
        tableImageView.addSubview(softStoolImageView)
        tableImageView.addSubview(goodStoolImageView)
        tableImageView.addSubview(hardStoolImageView)
        tableImageView.addSubview(largeTextLabel)
        tableImageView.addSubview(mediumTextLabel)
        tableImageView.addSubview(smallTextLabel)
        tableImageView.addSubview(largeSoftCountTextLabel)
        tableImageView.addSubview(largeGoodCountTextLabel)
        tableImageView.addSubview(largeHardCountTextLabel)
        tableImageView.addSubview(mediumSoftCountTextLabel)
        tableImageView.addSubview(mediumGoodCountTextLabel)
        tableImageView.addSubview(mediumHardCountTextLabel)
        tableImageView.addSubview(smallSoftCountTextLabel)
        tableImageView.addSubview(smallGoodCountTextLabel)
        tableImageView.addSubview(smallHardCountTextLabel)
        
        tableImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        softStoolImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(46)
            make.centerX.equalToSuperview().multipliedBy(0.4)
        }
        
        goodStoolImageView.snp.makeConstraints { make in
            make.top.equalTo(softStoolImageView.snp.bottom).offset(17)
            make.centerX.equalTo(softStoolImageView)
        }
        
        hardStoolImageView.snp.makeConstraints { make in
            make.top.equalTo(goodStoolImageView.snp.bottom).offset(17)
            make.centerX.equalTo(softStoolImageView)
        }
        
        largeTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.centerX.equalToSuperview()
        }
        
        mediumTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.39)
            make.centerY.equalTo(largeTextLabel)
        }
        
        smallTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(largeTextLabel).multipliedBy(1.8)
            make.centerY.equalTo(largeTextLabel)
        }
        
        largeGoodCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(largeTextLabel)
            make.centerY.equalTo(goodStoolImageView)
        }
        
        largeSoftCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(largeTextLabel)
            make.centerY.equalTo(softStoolImageView)
        }
        
        largeHardCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(largeTextLabel)
            make.centerY.equalTo(hardStoolImageView)
        }
        
        mediumSoftCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(mediumTextLabel)
            make.centerY.equalTo(softStoolImageView)
        }
        
        mediumGoodCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(mediumTextLabel)
            make.centerY.equalTo(goodStoolImageView)
        }
        
        mediumHardCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(mediumTextLabel)
            make.centerY.equalTo(hardStoolImageView)
        }
        
        smallSoftCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(smallTextLabel)
            make.centerY.equalTo(softStoolImageView)
        }
        
        smallGoodCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(smallTextLabel)
            make.centerY.equalTo(goodStoolImageView)
        }
        
        smallHardCountTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(smallTextLabel)
            make.centerY.equalTo(hardStoolImageView)
        }
    }
}

extension ReportTotalSizeView {
    func updateCountLabels(with stoolShapeSizeCountMap: [StoolShapeSize: Int]) {
        for (shapeSize, count) in stoolShapeSizeCountMap {
            let label = labelFor(shape: shapeSize.shape, size: shapeSize.size)
            label.text = LocalizableString.count(count)
        }
    }
}

// MARK: - Supporting Methods

private extension ReportTotalSizeView {
    func labelFor(shape: StoolShape, size: StoolSize) -> UILabel {
        switch (shape, size) {
        case (.soft, .large):
            return largeSoftCountTextLabel
        case (.soft, .medium):
            return mediumSoftCountTextLabel
        case (.soft, .small):
            return smallSoftCountTextLabel
        case (.good, .large):
            return largeGoodCountTextLabel
        case (.good, .medium):
            return mediumGoodCountTextLabel
        case (.good, .small):
            return smallGoodCountTextLabel
        case (.hard, .large):
            return largeHardCountTextLabel
        case (.hard, .medium):
            return mediumHardCountTextLabel
        case (.hard, .small):
            return smallHardCountTextLabel
        }
    }
}
