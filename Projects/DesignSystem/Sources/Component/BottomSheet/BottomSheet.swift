//
//  BottomSheet.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import SnapKit
import UIKit

protocol BottomSheetCloseNotification: NSObject {
    func notifyBottomSheetClosed()
}

public final class BottomSheet: UIControl {
    
    private let topBarArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.roundCorners(radius: 4)
        return view
    }()
    
    var contentBackgroundView = UIView()
    private var minTopOffset: CGFloat = .zero
    private var maxTopOffset: CGFloat = .zero
    private (set)var defaultHeight: CGFloat = .zero
    private var isClosed = false {
        didSet {
            guard isClosed == true else { return }
            delegate?.notifyBottomSheetClosed()
        }
    }
    
    weak var delegate: BottomSheetCloseNotification?
    
    convenience init(_ superViewHeight: CGFloat, _ bottomSheetHeight: CGFloat) {
        self.init()
        self.maxTopOffset = superViewHeight
        self.minTopOffset = superViewHeight - bottomSheetHeight
        self.defaultHeight = bottomSheetHeight
        setupViews()
        addPanGestureRecognizer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addPanGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        topBarArea.addGestureRecognizer(recognizer)
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        
        //이동된 y 거리 계산
        let updatedY = frame.minY + recognizer.translation(in: self).y
        
        //updatedY의 범위가 기존의 topOffset 이하인 지 판별
        if (minTopOffset...maxTopOffset) ~= updatedY {
            updateConstraints(updatedY)
            recognizer.setTranslation(.zero, in: self)
        }
        UIView.animate(withDuration: 0.0, delay: .zero, animations: layoutIfNeeded)
        
        //recognizer이 끝났을 때 상태 업데이트
        guard recognizer.state == .ended else { return }
        let isDownward = recognizer.velocity(in: self).y > 0
        let yPosition: CGFloat = isDownward ? (updatedY > maxTopOffset*0.8 ? maxTopOffset : minTopOffset) : minTopOffset
        
        updateConstraints(yPosition)
        
        if yPosition >= maxTopOffset {
            isClosed = true
        }
        
        UIView.animate(withDuration: 0.4, delay: .zero, animations: layoutIfNeeded)
    }
    
    private func setupViews() {
        
        self.roundCorners(corners: [.topLeft, .topRight], radius: 30)

        addSubview(topBarArea)
        topBarArea.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(21)
        }
        
        topBarArea.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(7)
        }
        
        addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(topBarArea.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension BottomSheet {
    
    func set(contentView: UIView) {
        contentBackgroundView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateConstraints(_ topOffset: CGFloat) {
        self.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(defaultHeight)
        }
    }
    
    func move(upTo topOffset: CGFloat,
              duration: CGFloat,
              animation: @escaping () -> Void,
              completion: @escaping (Bool) -> Void = { _ in }) {
        
        updateConstraints(topOffset)
        
        UIView.animate(
            withDuration: duration,
            delay: .zero,
            animations: animation,
            completion: completion
        )
    }
}
