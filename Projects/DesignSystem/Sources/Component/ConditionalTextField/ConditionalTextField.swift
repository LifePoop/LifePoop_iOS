//
//  ConditionalTextField.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

final public class ConditionalTextField: UIControl {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ColorAsset.pooBlack.color
        label.sizeToFit()
        return label
    }()
    
    private let essentialMark: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ColorAsset.primary.color
        label.text = "*"
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    private let separatorView: SeparatorView = {
        let view = SeparatorView()
        view.backgroundColor = ColorAsset.pooBlack.color
        return view
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.gray800.color
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 44))
        toolbar.backgroundColor = .systemBackground
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneBarButtonItem], animated: true)
        return toolbar
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: DesignSystemStrings.done,
            style: .done,
            target: nil,
            action: #selector(tapDoneBarButton)
        )
        return barButtonItem
    }()
    
    public enum TextFieldStatus {
        case `default`(text: String)
        case impossible(text: String)
        case possible(text: String)
    }
    
    public var status: TextFieldStatus? {
        didSet {
            guard let status = status else { return }
            
            switch status {
            case .`default`(let text):
                subLabel.textColor = ColorAsset.gray800.color
                subLabel.text = text
            case .impossible(let text):
                subLabel.textColor = ColorAsset.pooPink.color
                subLabel.text = text
            case .possible(let text):
                subLabel.textColor = ColorAsset.primary.color
                subLabel.text = text
            }
        }
    }
    
    public var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var text: String? {
        didSet {
            textField.text = text ?? ""
            sendActions(for: .valueChanged)
        }
    }
    
    public var markAsEssential: Bool = false {
        didSet {
            essentialMark.isHidden = !markAsEssential
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let sumOfSubViewsHeight = self.subviews.reduce(0) { $0 + $1.bounds.height }
        let sumOfMargins: CGFloat = 42
        let totalHeight = sumOfSubViewsHeight + sumOfMargins
        
        return CGSize(width: bounds.width, height: totalHeight)
    }
    
    public init(keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        textField.keyboardType = keyboardType
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        text = textField.text
    }
    
    @objc private func tapDoneBarButton() {
        textField.resignFirstResponder()
    }
    
    private func configureUI() {
        
        addSubview(titleLabel)
        addSubview(essentialMark)
        addSubview(textField)
        addSubview(separatorView)
        addSubview(subLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        essentialMark.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
    }
}

extension ConditionalTextField: UITextFieldDelegate {
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
 
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendActions(for: .editingDidEndOnExit)
        return true
    }
}
