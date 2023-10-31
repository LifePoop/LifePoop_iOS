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

import CoreEntity
import DesignSystem
import Utils

final class ReportTotalShapeView: UIView {
    
    private lazy var tableImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.reportShapeRanking.original)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var firstStoolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var secondStoolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var thirdtoolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var firstTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var secondTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var thirdTextLabel: UILabel = {
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
        addSubview(firstStoolImageView)
        addSubview(secondStoolImageView)
        addSubview(thirdtoolImageView)
        addSubview(firstTextLabel)
        addSubview(secondTextLabel)
        addSubview(thirdTextLabel)
        
        tableImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        firstStoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(-1)
            make.centerX.equalToSuperview()
        }
        
        secondStoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(15)
            make.centerX.equalToSuperview().multipliedBy(0.35)
        }
        
        thirdtoolImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tableImageView.snp.top).offset(25)
            make.centerX.equalToSuperview().multipliedBy(1.65)
        }
        
        firstTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(firstStoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(firstStoolImageView)
        }
        
        secondTextLabel.snp.makeConstraints { make in
            make.bottom.equalTo(secondStoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(secondStoolImageView)
        }
        
        thirdTextLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thirdtoolImageView.snp.top).offset(-11)
            make.centerX.equalTo(thirdtoolImageView)
        }
    }
}

extension ReportTotalShapeView {
    func updateTotalShape(by stoolShapeCountMap: [StoolShape: Int]) {
        let sortedShapes = stoolShapeCountMap.sorted { $0.value > $1.value }
        let stoolShapeTypeCount = StoolShape.allCases.count
        
        guard sortedShapes.count >= stoolShapeTypeCount else { return }
        
        let imageViews = [firstStoolImageView, secondStoolImageView, thirdtoolImageView]
        let labels = [firstTextLabel, secondTextLabel, thirdTextLabel]
        
        for index in 0..<stoolShapeTypeCount {
            let shape = sortedShapes[index].key
            let count = sortedShapes[index].value
            setImageViewAndLabel(for: shape, count: count, imageView: imageViews[index], label: labels[index])
        }
    }
}

// MARK: - Supporting Methods
 
private extension ReportTotalShapeView {
    private func setImageViewAndLabel(for shape: StoolShape, count: Int, imageView: UIImageView, label: UILabel) {
        var imageAsset: UIImage?
        var localizableString: String?
        var countString: (Int) -> String
        
        switch shape {
        case .soft:
            imageAsset = ImageAsset.stoolSmallSoftBlue.original
            localizableString = LocalizableString.watery
            countString = LocalizableString.wateryCount
        case .good:
            imageAsset = ImageAsset.stoolSmallGoodBlue.original
            localizableString = LocalizableString.smooth
            countString = LocalizableString.smoothCount
        case .hard:
            imageAsset = ImageAsset.stoolSmallHardBlue.original
            localizableString = LocalizableString.hard
            countString = LocalizableString.hardCount
        }
        
        imageView.image = imageAsset
        label.text = countString(count)
        
        if let shapeString = localizableString, let shapeStringRange = label.rangeOfString(target: shapeString) {
            label.applyFont(.systemFont(ofSize: 16, weight: .medium), range: shapeStringRange)
        }
    }
}
