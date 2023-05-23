//
//  SettingTableViewDelegate.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift

public final class SettingTableViewDelegate: NSObject, UITableViewDelegate {
    
    let footerViewModel = BehaviorRelay<SettingTableFooterViewModel?>(value: nil)
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = SettingListSection(rawValue: section)?.title else {
            return UIView()
        }
        let headerView = SettingTableHeaderView()
        headerView.setTitle(title)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == tableView.numberOfSections - 1 else {
            return UIView()
        }
        let footerView = SettingTableFooterView()
        if let viewModel = footerViewModel.value {
            footerView.bind(viewModel: viewModel)
        }
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == tableView.numberOfSections - 1 else {
            return .zero
        }
        return 120
    }
}
