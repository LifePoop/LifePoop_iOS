//
//  FeatureStoolLogDIContainer.swift
//  ProjectDescriptionHelpers
//
//  Created by 이준우 on 2023/05/03.
//

import Foundation
import Utils

public final class StoolLogDIContainer: DIContainer {
    
    public var storage: [String : Any] = [:]
    
    public static let shared = StoolLogDIContainer()
    
    private init() { }
}
