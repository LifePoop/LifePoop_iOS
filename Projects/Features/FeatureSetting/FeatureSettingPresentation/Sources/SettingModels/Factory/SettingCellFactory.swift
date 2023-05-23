//
//  SettingCellFactory.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/23.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

struct SettingCellFactory {
    static func dequeueAndBindCell(
        _ tableView: UITableView,
        at indexPath: IndexPath,
        with viewModel: any SettingCellViewModel
    ) -> UITableViewCell {
        let cellDisplayType = SettingModelDisplayTypeMapper.mapDisplayType(for: viewModel.model)
        switch cellDisplayType {
        case .loginType:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingLoginTypeTableViewCell.identifier,
                for: indexPath
            ) as? SettingLoginTypeTableViewCell,
            let viewModel = viewModel as? SettingLoginTypeCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .switch:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingSwitchTableViewCell.identifier,
                for: indexPath
            ) as? SettingSwitchTableViewCell,
            let viewModel = viewModel as? SettingSwitchCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .tap:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTapActionTableViewCell.identifier,
                for: indexPath
            ) as? SettingTapActionTableViewCell,
            let viewModel = viewModel as? SettingTapActionCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTextTableViewCell.identifier,
                for: indexPath
            ) as? SettingTextTableViewCell,
            let viewModel = viewModel as? SettingTextCellViewModel else { return UITableViewCell() }
            cell.bind(viewModel: viewModel)
            return cell
        }
    }
}
