//
//  UIViewController+blockScreen.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/12/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

private var blockViewKey: Void?

private final class BlockView: UIView {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDimmedEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDimmedEffect()
    }
    
    
    private func setDimmedEffect() {
        backgroundColor = .black.withAlphaComponent(0.5)

        addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

public extension UIViewController {

    private var blockView: BlockView? {
        get {
            objc_getAssociatedObject(self, &blockViewKey) as? BlockView
        }
        set {
            if let previousView = blockView {
                previousView.removeFromSuperview()
            }
            
            objc_setAssociatedObject(self, &blockViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func blockScreen() {
        self.addBlockView()

        view.isUserInteractionEnabled = true
        navigationItem.hidesBackButton = true
    }
    
    func unblockScreen() {
        self.removeBlockView()
        
        view.isUserInteractionEnabled = true
        navigationItem.hidesBackButton = false
    }
    
    private func addBlockView() {
        let blockView = BlockView()
        blockView.translatesAutoresizingMaskIntoConstraints = false
        self.blockView = blockView

        view.addSubview(blockView)
        NSLayoutConstraint.activate([
            blockView.topAnchor.constraint(equalTo: view.topAnchor),
            blockView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.setNeedsLayout()
    }
    
    private func removeBlockView() {
        blockView?.removeFromSuperview()
        blockView = nil
    }
}
