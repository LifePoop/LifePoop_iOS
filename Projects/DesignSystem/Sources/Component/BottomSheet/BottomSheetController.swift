//
//  BottomSheetController.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import SnapKit
import UIKit

@objc public protocol BottomSheetDelegate {
    
    @objc optional func bottomSheetDidAppear()
    func bottomSheetDidDisappear()
}

public final class BottomSheetController: UIViewController {
    
    private var bottomSheet: BottomSheet?
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()
    
    private var bottomSheetHeight: CGFloat = .zero

    private (set)weak var contentViewController: UIViewController?
    
    public weak var delegate: BottomSheetDelegate?
    
    convenience public init(bottomSheetHeight: CGFloat) {
        self.init()
        self.bottomSheetHeight = bottomSheetHeight
        
        let bottomSheet = BottomSheet(view.bounds.height, bottomSheetHeight)
        self.bottomSheet = bottomSheet
        setupViews()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomSheet?.move(
            upTo: view.bounds.height - bottomSheetHeight,
            duration: 0.3,
            animation: view.layoutIfNeeded
        ) { [weak self] _ in
            self?.delegate?.bottomSheetDidAppear?()
        }
    }
    
    public func setBottomSheet(contentViewController: UIViewController) {
        guard let bottomSheet = self.bottomSheet else { return }
        
        if let contentViewController = self.contentViewController {
            contentViewController.willMove(toParent: nil)
            contentViewController.view.removeFromSuperview()
            contentViewController.removeFromParent()
        }

        addChild(contentViewController)
        bottomSheet.set(contentView: contentViewController.view)
        contentViewController.didMove(toParent: self)

        self.contentViewController = contentViewController
    }
    
    public func showBottomSheet(toParent parentViewController: UIViewController, completion: (() -> Void)? = nil) {
        
        parentViewController.addChild(self)
        view.frame = parentViewController.view.bounds
        parentViewController.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        dimmedView.isHidden = false
        self.didMove(toParent: parentViewController)
    }
    
    @objc public func closeBottomSheet() {

        self.dimmedView.isHidden = true

        bottomSheet?.move(
            upTo: view.bounds.height,
            duration: 0.25,
            animation: view.layoutIfNeeded
        ) { [weak self] _ in
            
            self?.view?.removeFromSuperview()
            self?.delegate?.bottomSheetDidDisappear()
            self?.removeFromParent()
        }
    }
}

extension BottomSheetController: BottomSheetCloseNotification {
    
    func notifyBottomSheetClosed() {
        closeBottomSheet()
    }
}

private extension BottomSheetController {
    
    func setupViews() {
        guard let bottomSheet = bottomSheet else { return }
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet))
        dimmedView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(bottomSheetHeight)
            make.leading.trailing.equalToSuperview()
        }
        
        bottomSheet.delegate = self
    }
}
