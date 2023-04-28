//
//  ToastMessage.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum ToastMessage {
    case failToFetchAccessToken
    case failToFetchImageData
    
    public var localized: String { // TODO: Localizing
        switch self {
        case .failToFetchAccessToken:
            return "사용자 인증 토큰을 불러오는 데 실패했습니다."
        case .failToFetchImageData:
            return "이미지 데이터를 불러오는 데 실패했습니다."
        }
    }
}
