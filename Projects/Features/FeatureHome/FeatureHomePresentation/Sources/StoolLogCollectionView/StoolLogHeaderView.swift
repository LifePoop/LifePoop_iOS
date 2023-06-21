//
//  StoolLogHeaderView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import DesignSystemReactive
import Utils

public final class StoolLogHeaderView: UICollectionReusableView, ViewType {
    
    private let todayStoolLogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let cheeringButtonView = CheeringButtonView()
    
    public var viewModel: StoolLogHeaderViewModel?
    private var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: StoolLogHeaderViewModel) {
        let input = viewModel.input
        
        input.viewDidLoad.accept(())
        
        cheeringButtonView.rx.tap
            .bind(to: input.cheeringButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: StoolLogHeaderViewModel) {
        let output = viewModel.output
        
        output.setDateDescription
            .bind(to: todayStoolLogLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.setFriendsCheeringDescription
            .bind(to: cheeringButtonView.rx.titleText)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension StoolLogHeaderView {
    func layoutUI() {
        addSubview(todayStoolLogLabel)
        addSubview(cheeringButtonView)
        
        todayStoolLogLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        cheeringButtonView.snp.makeConstraints { make in
            make.top.equalTo(todayStoolLogLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
    }
}
