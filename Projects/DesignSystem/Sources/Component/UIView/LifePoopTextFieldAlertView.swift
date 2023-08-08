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
        textField.delegate = self
        return textField
    }()
    
    public var textFieldInputAccessoryView: UIView? {
        textField.inputAccessoryView
    }

    private var warningLabel: UILabel = {
        let label = UILabel()
        label.text = DesignSystemStrings.requestCorrectInvitationCodeInput
        label.textColor = ColorAsset.pooPink.color
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    public var text: String? {
        didSet {
            textField.text = text ?? ""
            sendActions(for: .valueChanged)
        }
    }
    
    public var isConfirmButtonEnabled: Bool = false {
        didSet {
            super.confirmButton.isEnabled = isConfirmButtonEnabled
        }
    }
    
    public var isWarningLabelhidden: Bool = false {
        didSet {
            self.warningLabel.isHidden = isWarningLabelhidden
        }
    }
    
    public init(type: LifePoopAlertViewType, placeholder: String) {
        super.init(type: type)
        
        textField.placeholder = placeholder
        layoutUI()
        configureUI()
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
        addSubview(warningLabel)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(super.descriptionLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(23)
            make.height.equalTo(45)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(23)
        }
        
        super.buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func configureUI() {
        addPasteButtonToKeyboard()
    }
    
    private func addPasteButtonToKeyboard() {
        guard let clipboardString = UIPasteboard.general.string,
              clipboardString.count == 8 else { return }
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let pasteButton = UIBarButtonItem(
            title: DesignSystemStrings.paste,
            style: .plain,
            target: self,
            action: #selector(pasteButtonTapped)
        )
        
        let toolbar = UIToolbar()
        toolbar.items = [flexibleSpace, pasteButton]
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func pasteButtonTapped() {
        guard let clipboardString = UIPasteboard.general.string else { return }
        text = clipboardString
        textField.resignFirstResponder()
    }
}

extension LifePoopTextFieldAlertView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
