//
//  ReportDIContainer.swift
//  FeatureReportDIContainer
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public final class ReportDIContainer: DIContainer {
    
    public var storage: [String: Any] = [:]
    
    public static let shared = ReportDIContainer()
    
    private init() { }
}
