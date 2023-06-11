//
//  ReportViewController.swift
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
import DesignSystemReactive
import Utils

public final class ReportViewController: LifePoopViewController, ViewType {
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private lazy var totalBowelMovementsContainerView: ReportContainerView = {
        let innerView = ReportTotalBowelMovementsView()
        return ReportContainerView(
            title: "총 배변 횟수",
            innerView: innerView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 23, left: 16, bottom: 23, right: 16))
        )
    }()
    
    private lazy var totalSatisfactionContainerView: ReportContainerView = {
        let innerView = ReportTotalSatisfactionView()
        return ReportContainerView(
            title: "만족도",
            innerView: innerView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
        )
    }()
    
    private lazy var totalColorContainerView: ReportContainerView = {
        let innerView = ReportTotalColorView()
        return ReportContainerView(
            title: "색깔",
            innerView: innerView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
        )
    }()
    
    private lazy var totalShapeContainerView: ReportContainerView = {
        let innerView = ReportTotalShapeView()
        return ReportContainerView(
            title: "모양",
            innerView: innerView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 16, left: 12.5, bottom: 16, right: 12.5))
        )
    }()
    
    private lazy var totalSizeContainerView: ReportContainerView = {
        let innerView = ReportTotalSizeView()
        return ReportContainerView(
            title: "크기",
            innerView: innerView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 16, left: 13.5, bottom: 16, right: 13.5))
        )
    }()
    
    public var viewModel: ReportViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ReportViewModel) {
        let input = viewModel.input
        
    }
    
    public func bindOutput(from viewModel: ReportViewModel) {
        let output = viewModel.output
        
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(totalBowelMovementsContainerView)
        scrollContentView.addSubview(totalSatisfactionContainerView)
        scrollContentView.addSubview(totalColorContainerView)
        scrollContentView.addSubview(totalShapeContainerView)
        scrollContentView.addSubview(totalSizeContainerView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(totalSizeContainerView.snp.bottom).offset(32)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        totalBowelMovementsContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        totalSatisfactionContainerView.snp.makeConstraints { make in
            make.top.equalTo(totalBowelMovementsContainerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        totalColorContainerView.snp.makeConstraints { make in
            make.top.equalTo(totalSatisfactionContainerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        totalShapeContainerView.snp.makeConstraints { make in
            make.top.equalTo(totalColorContainerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        totalSizeContainerView.snp.makeConstraints { make in
            make.top.equalTo(totalShapeContainerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
