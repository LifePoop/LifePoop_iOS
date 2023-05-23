//
//  DocumentViewController.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/23.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

open class DocumentViewController: LifePoopViewController {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 10, left: 24, bottom: 20, right: 24)
        textView.contentInsetAdjustmentBehavior = .never
        textView.font = .systemFont(ofSize: 12)
        textView.isEditable = false
        return textView
    }()
    
    public init(title: String, text: String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        textView.text = text
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
