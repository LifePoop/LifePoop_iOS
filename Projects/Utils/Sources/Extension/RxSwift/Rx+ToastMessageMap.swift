//
//  Rx+ToastMessageMap.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/28.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

public extension ObservableType {
    func toastMeessageMap(to toastMessage: ToastMessage) -> Observable<String> {
        return map { _ in toastMessage.localized }
    }
}
