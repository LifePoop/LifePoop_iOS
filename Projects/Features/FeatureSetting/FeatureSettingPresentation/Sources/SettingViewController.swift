//
//  SettingViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class SettingViewController: LifePoopViewController, ViewType {
    
    private let settingTableViewDelegate = SettingTableViewDelegate()
    private let settingTableViewDataSource = SettingTableViewDataSource()
    private lazy var settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SettingLoginTypeTableViewCell.self,
            forCellReuseIdentifier: SettingLoginTypeTableViewCell.identifier
        )
        tableView.register(
            SettingSwitchTableViewCell.self,
            forCellReuseIdentifier: SettingSwitchTableViewCell.identifier
        )
        tableView.register(
            SettingTapActionTableViewCell.self,
            forCellReuseIdentifier: SettingTapActionTableViewCell.identifier
        )
        tableView.register(
            SettingTextTableViewCell.self,
            forCellReuseIdentifier: SettingTextTableViewCell.identifier
        )
        tableView.register(
            SettingTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SettingTableHeaderView.identifier
        )
        tableView.register(
            SettingTableFooterView.self,
            forHeaderFooterViewReuseIdentifier: SettingTableFooterView.identifier
        )
        
        tableView.delegate = settingTableViewDelegate
        tableView.dataSource = settingTableViewDataSource
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.sectionHeaderHeight = 58
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private let logoutAlertView = LifePoopAlertView(type: .logout)
    
    public var viewModel: SettingViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: SettingViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        settingTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.settingTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        logoutAlertView.cancelButton.rx.tap
            .bind(to: input.logoutCancelButtonDidTap)
            .disposed(by: disposeBag)
        
        logoutAlertView.confirmButton.rx.tap
            .bind(to: input.logoutConfirmButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SettingViewModel) {
        let output = viewModel.output
        
        output.settingCellViewModels
            .asDriver()
            .drive(onNext: settingTableViewDataSource.setCellViewModels)
            .disposed(by: disposeBag)
        
        output.footerViewModel
            .asDriver()
            .drive(settingTableViewDelegate.footerViewModel)
            .disposed(by: disposeBag)
        
        output.showLogoutAlert
            .asSignal()
            .withUnretained(self)
            .emit { `self`, _ in
                guard let view = self.navigationController?.view else { return }
                self.logoutAlertView.show(in: view)
            }
            .disposed(by: disposeBag)
        
        output.dismissLogoutAlert
            .asSignal()
            .emit(onNext: logoutAlertView.dismiss)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = LocalizableString.settingTitle
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(settingTableView)
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
