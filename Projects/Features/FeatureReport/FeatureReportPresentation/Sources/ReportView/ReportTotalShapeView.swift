//
//  ReportTotalShapeView.swift
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

final class ReportTotalShapeView: UIView {
    
    private lazy var tableImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.reportShapeRanking.original)
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
    
    private lazy var softTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.wateryCount(6) // TODO: UseCase 처리
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var goodTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.smoothCount(10) // TODO: UseCase 처리
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var hardTextLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.hardCount(10) // TODO: UseCase 처리
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
        addSubview(softStoolImageView)
        addSubview(goodStoolImageView)
        addSubview(hardStoolImageView)
        addSubview(softTextLabel)
        addSubview(goodTextLabel)
        addSubview(hardTextLabel)
        
        tableImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        softStoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(15)
            make.centerX.equalToSuperview().multipliedBy(0.35)
        }
        
        goodStoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(-1)
            make.centerX.equalToSuperview()
        }
        
        hardStoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(25)
            make.centerX.equalToSuperview().multipliedBy(1.65)
        }
        
        softTextLabel.snp.makeConstraints { make in
            make.bottom.equalTo(softStoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(softStoolImageView)
        }
        
        goodTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(goodStoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(goodStoolImageView)
        }
        
        hardTextLabel.snp.makeConstraints { make in
            make.bottom.equalTo(hardStoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(hardStoolImageView)
        }
    }
}
