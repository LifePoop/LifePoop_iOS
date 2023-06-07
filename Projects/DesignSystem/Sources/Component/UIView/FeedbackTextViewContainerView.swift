//
//  FeedbackTextViewContainerView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/24.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

public final class FeedbackTextViewContainerView: UIView {
    
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
            title: "완료",
            style: .done,
            target: nil,
            action: #selector(tapDoneBarButton)
        )
        return barButtonItem
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        textView.backgroundColor = ColorAsset.gray200.color
        textView.layer.cornerRadius = 6
        textView.inputAccessoryView = toolbar
        return textView
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.gray900.color
        label.text = textCountLabelText
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var isPlaceholderVisible: Bool {
        return textView.text == placeholder && textView.textColor == placeholderTextColor
    }
    
    public var text: String? {
        return textView.text
    }
    
    public var currentTextCount: Int = .zero
    private let maximumTextCount: Int
    private let editingTextColor = ColorAsset.gray900.color
    private let placeholderTextColor = ColorAsset.gray800.color
    private let placeholder: String?
    
    private var textCountLabelText: String {
        return "\(currentTextCount)/\(maximumTextCount)"
    }
    
    public init(placeholder: String? = nil, maximumTextCount: Int) {
        self.placeholder = placeholder
        self.maximumTextCount = maximumTextCount
        super.init(frame: .zero)
        layoutUI()
        setPlaceholder()
        textView.delegate = self
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Layout

private extension FeedbackTextViewContainerView {
    func layoutUI() {
        addSubview(textView)
        addSubview(textCountLabel)
        
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
    }
}

// MARK: - Supporting Methods

private extension FeedbackTextViewContainerView {
    private func setPlaceholder() {
        textView.textColor = placeholderTextColor
        textView.text = placeholder
    }
    
    @objc private func tapDoneBarButton() {
        textView.resignFirstResponder()
    }
}

// MARK: - TextField Delegate Methods

extension FeedbackTextViewContainerView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderVisible {
            textView.text = ""
            textView.textColor = editingTextColor
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholder()
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        currentTextCount = textView.text.count
        textCountLabel.text = textCountLabelText
    }
    
    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maximumTextCount
    }
}
