//
//  LifePoopWebViewController.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit
import WebKit

@available(*, deprecated, message: "피드백 URL이 Safari에서 열리도록 변경되어 더 이상 사용하지 않음")
public final class LifePoopWebViewController: UIViewController {
    
    private var webView: WKWebView?
    private let targetURL: URL
    
    public init(webView: WKWebView? = nil, targetURL: URL) {
        self.webView = webView
        self.targetURL = targetURL
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: targetURL)
        webView?.load(request)
    }
}
