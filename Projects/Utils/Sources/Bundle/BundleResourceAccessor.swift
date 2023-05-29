//
//  BundleResourceAccessor.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct BundleResourceAccessor {
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public static func readText(from file: TextFile) -> String? {
        guard let path = Bundle.utils?.path(forResource: file.name, ofType: "txt") else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}
