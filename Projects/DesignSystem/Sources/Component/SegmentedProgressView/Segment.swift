//
//  Segment.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

final class Segment: UIView {
    
    private let trackedMark: UIView = {
        let view = UIView()
        view.backgroundColor = ColorAsset.primary.color
        return view
    }()

    private let unTrackedmark: UIView = {
        let view = UIView()
        view.backgroundColor = ColorAsset.white.color
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = 2.5
    }
    
    private func layoutUI() {
        
        let segmentWidth = frame.width
        let segmentHeight = frame.height
        
        unTrackedmark.frame = CGRect(origin: .zero, size: .init(width: segmentWidth, height: segmentHeight))
        trackedMark.frame = CGRect(origin: .zero, size: .init(width: .zero, height: segmentHeight))
        
        addSubview(unTrackedmark)
        addSubview(trackedMark)
    }
    
    func setTracked(animated: Bool = false, completion: (() -> Void)? = nil) {
        if isAlreadyTracked() { return }

        let segmentWidth = frame.width

        trackedMark.frame.size.width = segmentWidth
    }
    
    func setUntracked() {
        guard isAlreadyTracked() else { return }
        
        trackedMark.frame.size.width = .zero
    }
    
    private func isAlreadyTracked() -> Bool {
        trackedMark.frame.size.width > .zero
    }
}
