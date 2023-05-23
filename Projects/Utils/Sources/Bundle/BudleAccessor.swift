//
//  BudleAccessor.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public extension Foundation.Bundle {
    
    static var utils: Bundle? {
        return Bundle(identifier: "LifePoop.Utils")
    }
    
    func text(from file: TextFile) -> String? {
        guard let path = self.path(forResource: file.name, ofType: "txt") else {
            return nil
        }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}
