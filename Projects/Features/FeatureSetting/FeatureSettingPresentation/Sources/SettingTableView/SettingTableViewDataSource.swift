//
//  SettingTableViewDataSource.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

public final class SettingTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var sectionCellViewModelMap: [SettingListSection: [any SettingCellViewModel]] = [:]
    
    public func setCellViewModels(_ cellViewModels: [any SettingCellViewModel]) {
        cellViewModels.forEach { cellViewModel in
            let section = SettingSectionMapper.mapSection(for: cellViewModel.model)
            sectionCellViewModelMap[section, default: []].append(cellViewModel)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCellViewModelMap.keys.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingListSection(rawValue: section),
              let numberOfRows = sectionCellViewModelMap[section]?.count else { return .zero }
        return numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingListSection(rawValue: indexPath.section),
              let cellViewModelsInSection = sectionCellViewModelMap[section] else {
            return UITableViewCell()
        }
        
        let cellViewModel = cellViewModelsInSection[indexPath.row]
        return SettingCellFactory.dequeueAndBindCell(tableView, at: indexPath, with: cellViewModel)
    }
}
