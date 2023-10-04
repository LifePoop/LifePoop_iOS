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
    enum LottieResource {
        public static let onboarding = "onboarding"
    }
}

public extension Constant {
    enum LifePoopURL {
        public static let feedback = "https://docs.google.com/forms/d/1H9FBgTbP3y4Yw2pkdtXwQmwMrSTov1jl8CQ__ny_hsQ/edit"
    }
}

public extension Constant {
    enum ValidPattern {
        public static let nickname = "^[가-힣a-zA-Z0-9]{2,5}$"
    }
}

public extension Constant {
    enum DateFormat {
        public static let iso8601Format = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
}

public extension Constant {
    enum OSLogCategory {
        public static let `default` = "Default"
        public static let deallocation = "Deallocation"
        public static let bundle = "Bundle"
        public static let userDefaults = "UserDefaults"
        public static let network = "Network"
        public static let database = "Database"
        public static let keyChain = "KeyChain"
        public static let authentication = "Authentication"
    }
}
