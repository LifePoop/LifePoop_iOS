//
//  Constant.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum Constant { }

public extension Constant {
    enum Text {
        
    }
}

public extension Constant {
    enum Image {
        
    }
}

public extension Constant {
    enum DateFormat {
        static let iso8601Format = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let userDisplayFormat = "yyyy년 M월 d일"
    }
}

public extension Constant {
    enum OSLogCategory {
        public static let `default` = "Default"
        public static let allocation = "Allocation"
        public static let network = "Network"
        public static let database = "Database"
    }
}
