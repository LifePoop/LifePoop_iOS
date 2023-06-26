//
//  FeedVisibility.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public enum FeedVisibility: Int, Codable, CaseIterable {
    case `private`
    case `public`
    
    public var text: String {
        switch self {
        case .private:
            return LocalizableString.privateStory
        case .public:
            return LocalizableString.publicStory
        }
    }
}
