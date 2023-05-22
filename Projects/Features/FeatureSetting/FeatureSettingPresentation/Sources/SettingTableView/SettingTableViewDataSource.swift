//
//  SettingTableViewDataSource.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class SettingTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var cellViewModels: [SettingListSection: [any SettingCellViewModel]] = [:]
    
    public func setCellViewModels(_ cellViewModels: [any SettingCellViewModel]) {
        self.cellViewModels = Dictionary(grouping: cellViewModels) {
            $0.model.section
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return cellViewModels.keys.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingListSection(rawValue: section),
              let numberOfRows = cellViewModels[section]?.count else { return .zero }
        return numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingListSection(rawValue: indexPath.section),
              let cellViewModelsInSection = cellViewModels[section] else {
            return UITableViewCell()
        }
        
        let cellViewModel = cellViewModelsInSection[indexPath.row]
        
        switch cellViewModel.model.displayType {
        case .loginType:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingLoginTypeTableViewCell.identifier,
                for: indexPath
            ) as? SettingLoginTypeTableViewCell else { return UITableViewCell() }
            guard let viewModel = cellViewModel as? SettingLoginTypeCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .switch:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingSwitchTableViewCell.identifier,
                for: indexPath
            ) as? SettingSwitchTableViewCell else { return UITableViewCell() }
            guard let viewModel = cellViewModel as? SettingSwitchCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .tap:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTapTableViewCell.identifier,
                for: indexPath
            ) as? SettingTapTableViewCell else { return UITableViewCell() }
            guard let viewModel = cellViewModel as? SettingTapCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .textTap:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTextTapTableViewCell.identifier,
                for: indexPath
            ) as? SettingTextTapTableViewCell else { return UITableViewCell() }
            guard let viewModel = cellViewModel as? SettingTextTapCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTextTableViewCell.identifier,
                for: indexPath
            ) as? SettingTextTableViewCell else { return UITableViewCell() }
            guard let viewModel = cellViewModel as? SettingTextCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        }
    }
}
