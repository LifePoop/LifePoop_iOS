//
//  FeedVisibility.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum FeedVisibility: Int, Codable, CaseIterable {
    case `private`
    case `public`
    
    public var text: String {
        switch self {
        case .private:
            return "나만 보기"
        case .public:
            return "전체 공개"
        }
    }
}
