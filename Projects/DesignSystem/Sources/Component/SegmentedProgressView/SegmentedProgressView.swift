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
        }
    }
    
    public var currentlyTrackedIndex: Int = 0 {
        didSet {
            trackSegment(forIndexOf: currentlyTrackedIndex)
        }
    }
    
    public var spacingBetweenSegments: CGFloat = .zero
    
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
}

private extension SegmentedProgressView {
    
    func clearAll() {
        segments = []
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    func createIndividualSegment(with rect: CGRect) -> Segment {
        Segment(frame: rect)
    }
    
    func trackSegment(forIndexOf targetIndex: Int) {
        guard segments.count == numberOfSegments else {
            fatalError("The size of the segments array must be equal to number of segments value in dataSource.")
        }
        
        guard targetIndex <= numberOfSegments else {
            fatalError("Given index value should be euqal or lower than number of segments.")
        }
        
        let endIndex = numberOfSegments-1
        let startIndex = 0

        segments[startIndex...targetIndex].forEach { $0.setUntracked() }
        
        guard targetIndex+1 <= endIndex else { return }
        segments[targetIndex+1...endIndex].forEach { $0.setTracked() }
    }
}
