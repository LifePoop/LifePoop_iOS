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

import CoreEntity
import DesignSystem
import DesignSystemReactive
import EntityUIMapper
import Utils

public final class ReportViewController: LifePoopViewController, ViewType {
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private let periodSegmentControl = LifePoopSegmentControl()
    
    private let reportTotalStoolCountView = ReportTotalStoolCountView()
    private lazy var totalStoolCountContainerView: ReportContainerView = {
        return ReportContainerView(
            title: "총 배변 횟수",
            innerView: reportTotalStoolCountView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 23, left: 16, bottom: 23, right: 16))
        )
    }()
    
    private let reportTotalSatisfactionView = ReportTotalSatisfactionView()
    private lazy var totalSatisfactionContainerView: ReportContainerView = {
        return ReportContainerView(
            title: "만족도",
            innerView: reportTotalSatisfactionView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
        )
    }()
    
    private let reportTotalColorView = ReportTotalColorView()
    private lazy var totalColorContainerView: ReportContainerView = {
        return ReportContainerView(
            title: "색깔",
            innerView: reportTotalColorView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
        )
    }()
    
    private let reportTotalShapeView = ReportTotalShapeView()
    private lazy var totalShapeContainerView: ReportContainerView = {
        return ReportContainerView(
            title: "모양",
            innerView: reportTotalShapeView,
            innerViewInsetPadding: Padding.custom(UIEdgeInsets(top: 16, left: 12.5, bottom: 16, right: 12.5))
        )
    }()
    
    private let reportTotalSizeView = ReportTotalSizeView()
    private lazy var totalSizeContainerView: ReportContainerView = {
        return ReportContainerView(
            title: "크기",
            innerView: reportTotalSizeView,
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
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        periodSegmentControl.rx.selectedSegmentIndex
            .bind(to: input.periodDidSelect)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: ReportViewModel) {
        let output = viewModel.output
        
        output.updatePeriodSegmentTitles
            .asSignal()
            .emit(onNext: periodSegmentControl.setTitles(_:))
            .disposed(by: disposeBag)
        
        output.selectPeriodSegmentIndexAt
            .asSignal()
            .emit(to: periodSegmentControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        output.updateStoolCountInfo
            .asSignal()
            .emit(onNext: reportTotalStoolCountView.update(nickname:periodText:count:))
            .disposed(by: disposeBag)
        
        output.totalSatisfaction
            .asSignal()
            .emit(onNext: reportTotalSatisfactionView.update(satisfactionCount:))
            .disposed(by: disposeBag)
        
        output.totalDissatisfaction
            .asSignal()
            .emit(onNext: reportTotalSatisfactionView.update(dissatisfactionCount:))
            .disposed(by: disposeBag)
        
        output.totalStoolColor
            .asSignal()
            .emit(onNext: reportTotalColorView.updateColorBars(with:))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = "변 기록 리포트"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(periodSegmentControl)
        scrollContentView.addSubview(totalStoolCountContainerView)
        scrollContentView.addSubview(totalSatisfactionContainerView)
        scrollContentView.addSubview(totalColorContainerView)
        scrollContentView.addSubview(totalShapeContainerView)
        scrollContentView.addSubview(totalSizeContainerView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(totalSizeContainerView.snp.bottom).offset(32)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        periodSegmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        
        totalStoolCountContainerView.snp.makeConstraints { make in
            make.top.equalTo(periodSegmentControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        totalSatisfactionContainerView.snp.makeConstraints { make in
            make.top.equalTo(totalStoolCountContainerView.snp.bottom).offset(28)
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
