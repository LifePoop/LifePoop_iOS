//
//  ReportTotalSatisfactionView.swift
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

final class ReportTotalSatisfactionView: UIView {
    
    private lazy var satisfactionThumbImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.thumbSatisfactionCircular.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var satisfactionCountLabel: UILabel = {
        let label = UILabel()
        label.text = "N번"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var satisfactionLabel: UILabel = {
        let label = UILabel()
        label.text = "만족"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var dissatisfactionThumbImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.thumbDissatisfactionCircular.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dissatisfactionCountLabel: UILabel = {
        let label = UILabel()
        label.text = "N번"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var dissatisfactionLabel: UILabel = {
        let label = UILabel()
        label.text = "불만족"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var satisfactionCount: Int = 0 {
        didSet {
            satisfactionCountLabel.startCountingAnimation(upTo: satisfactionCount) { [weak self] animatingCount in
                self?.satisfactionCountLabel.text = "\(animatingCount)번"
            }
        }
    }
    
    private var dissatisfactionCount: Int = 0 {
        didSet {
            dissatisfactionCountLabel.startCountingAnimation(upTo: dissatisfactionCount) { [weak self] animatingCount in
                self?.dissatisfactionCountLabel.text = "\(animatingCount)번"
            }
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
    
    func update(satisfactionCount: Int) {
        self.satisfactionCount = satisfactionCount
    }
    
    func update(dissatisfactionCount: Int) {
        self.dissatisfactionCount = dissatisfactionCount
    }
    
    private func layoutUI() {
        addSubview(satisfactionThumbImageView)
        addSubview(satisfactionCountLabel)
        addSubview(satisfactionLabel)
        addSubview(dissatisfactionThumbImageView)
        addSubview(dissatisfactionCountLabel)
        addSubview(dissatisfactionLabel)
        
        satisfactionThumbImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(dissatisfactionThumbImageView.snp.top).offset(-20)
        }
        
        satisfactionCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(satisfactionThumbImageView)
            make.leading.equalTo(satisfactionThumbImageView.snp.trailing).offset(12)
        }
        
        satisfactionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(satisfactionThumbImageView)
            make.leading.equalTo(satisfactionCountLabel.snp.trailing).offset(6)
        }
        
        dissatisfactionThumbImageView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        
        dissatisfactionCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dissatisfactionThumbImageView)
            make.leading.equalTo(dissatisfactionThumbImageView.snp.trailing).offset(12)
        }
        
        dissatisfactionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dissatisfactionThumbImageView)
            make.leading.equalTo(dissatisfactionCountLabel.snp.trailing).offset(6)
        }
    }
}
