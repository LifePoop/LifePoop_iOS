//
//  UIViewController+showSystemAlert.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/11/07.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public extension UIViewController {

    func showSystemAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let defaultAction = UIAlertAction(
            title: LocalizableString.confirm,
            style: UIAlertAction.Style.default
        )
        alert.addAction(defaultAction)
        
        present(alert, animated: false, completion: completion)
    }
}
