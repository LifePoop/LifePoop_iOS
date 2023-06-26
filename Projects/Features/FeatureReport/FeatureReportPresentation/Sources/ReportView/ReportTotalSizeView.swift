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

import DesignSystem
import Utils

final class ReportTotalSizeView: UIView {
    
    private lazy var tableImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.reportSizeTable.original)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var softStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallSoftBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var goodStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallGoodBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var hardStoolImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.stoolSmallHardBlue.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var largeTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.large
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var mediumTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.medium
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var smallTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.small
        label.font = .systemFont(ofSize: 16)
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
    }
}
