//
//  LifePoopTextFieldAlertView.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

public final class LifePoopTextFieldAlertView: LifePoopAlertView {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.backgroundColor = ColorAsset.gray300.color
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 6
        textField.insertLeftPadding(of: 10)
        return textField
    }()
    
    public var text: String? {
        didSet {
            textField.text = text ?? ""
            sendActions(for: .valueChanged)
        }
    }
    
    public init(type: LifePoopAlertViewType, placeholder: String) {
        super.init(type: type)

        textField.placeholder = placeholder
        layoutUI()
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        text = textField.text
    }
    
    private func layoutUI() {

        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(super.descriptionLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(23)
            make.height.equalTo(45)
        }
        
        super.buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
