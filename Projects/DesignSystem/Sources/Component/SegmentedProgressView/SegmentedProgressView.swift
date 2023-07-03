//
//  SegmentedProgressView.swift
//  DesignSystem
//
//  Created by Lee, Joon Woo on 2023/06/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public final class SegmentedProgressView: UIView {
    
    private var segments: [Segment] = []
    
    public var numberOfSegments: Int = 0 {
        didSet {
            guard numberOfSegments > 0 else { return }
            drawSegments()
            doAnimation()
        }
    }
  
    /// Do not directly change the value from outside of SegmentedProgressView.
    public var currentlyTrackedIndex: Int = -1 {
        didSet {
            guard currentlyTrackedIndex < numberOfSegments else { return }
            trackSegment(forIndexOf: currentlyTrackedIndex)
            sendActions(for: .valueChanged)
        }
    }
        
    public var spacingBetweenSegments: CGFloat = .zero
    
    private var animation: UIViewPropertyAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    public final func drawSegments() {
        clearAll()
        
        let totalWidth = frame.width
        let remainingWidth = totalWidth - spacingBetweenSegments*(CGFloat(numberOfSegments)-1)
        let segmentWidth = remainingWidth/CGFloat(numberOfSegments)
        let segmentHeight = frame.height
        
        var originX: CGFloat = .zero
        let originY: CGFloat = .zero
        (0..<numberOfSegments).forEach { index in
            let index = CGFloat(index)
            originX = index*(segmentWidth+spacingBetweenSegments)
            let segment = createIndividualSegment(with:
                    CGRect(x: originX, y: originY, width: segmentWidth, height: segmentHeight)
            )
            segment.setUntracked()
            
            addSubview(segment)
            segments.append(segment)
        }
    }
    
    public func manuallyTrackSegment(forIndexOf targetIndex: Int) {
        if animation != nil {
            pauseAndStopAnimation()
        }

        trackSegment(forIndexOf: targetIndex-1)

        resumeAnimation(fromIndexOf: targetIndex)
    }
}

// MARK: Animation

extension SegmentedProgressView {
    
    func doAnimation(fromIndexOf targetIndex: Int = 0) {
        let animation = UIViewPropertyAnimator(duration: 6, curve: .linear) {
            self.currentlyTrackedIndex = targetIndex
            self.trackSegment(forIndexOf: targetIndex)
        }
        
        animation.addCompletion { position in
            guard position == .end else { return }
            
            let shouldProceed = (targetIndex+1 < self.segments.count)
            guard shouldProceed else {
                return
            }
            
            self.doAnimation(fromIndexOf: targetIndex+1)
        }
        
        self.animation = animation
        animation.startAnimation()
    }
    
    func pauseAndStopAnimation() {
        animation?.pauseAnimation()
        animation?.stopAnimation(false)
        animation?.finishAnimation(at: .start)
        animation = nil
    }
    
    func resumeAnimation(fromIndexOf targetIndex: Int) {
        doAnimation(fromIndexOf: targetIndex)
    }
}

// MARK: Drawing UI

extension SegmentedProgressView {

    func clearAll() {
        segments = []
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    func createIndividualSegment(with rect: CGRect) -> Segment {
        Segment(frame: rect)
    }
}

private extension SegmentedProgressView {
    
    func trackSegment(forIndexOf targetIndex: Int) {
        guard segments.count == numberOfSegments else {
            fatalError("The size of the segments array must be equal to number of segments value in dataSource.")
        }
        
        guard targetIndex <= numberOfSegments else {
            fatalError("Given index value should be euqal or lower than number of segments.")
        }
                
        let endIndex = numberOfSegments-1
        let startIndex = 0
        let targetIndex = targetIndex < 0 ? -1 : targetIndex
        
        if targetIndex >= startIndex {
            segments[startIndex...targetIndex].forEach { $0.setTracked() }
        }
        
        guard targetIndex+1 <= endIndex else { return }
        segments[targetIndex+1...endIndex].forEach { $0.setUntracked() }
    }
}
