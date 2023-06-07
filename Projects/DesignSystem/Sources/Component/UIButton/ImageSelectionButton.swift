//
//  ImageSelectionButton.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public final class ImageSelectionButton: UIButton {
    
    public let index: Int
    
    public init(selectedImage: UIImage? = nil, deselectedImage: UIImage? = nil, index: Int) {
        self.index = index
        super.init(frame: .zero)
        setImage(selectedImage, for: .selected)
        setImage(deselectedImage, for: .normal)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setSelectedImage(_ image: UIImage) {
        setImage(image, for: .selected)
    }
    
    public func toggleSelection(isSelected: Bool) {
        self.isSelected = isSelected
    }
}
