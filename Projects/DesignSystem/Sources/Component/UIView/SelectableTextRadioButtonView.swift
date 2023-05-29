//
//  SelectableTextRadioButtonView.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

public class SelectableTextRadioButtonView: UIView {
    
    public let index: Int
    private let selectedImage = ImageAsset.btnRadioSelected.original
    private let deselectedImage = ImageAsset.btnRadioDeselected.original
    private var isSelected = false
    
    public var imagePadding: ImagePadding {
        return .medium
    }
    
    public lazy var containerButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.isSelected.toggle()
            self.toggleRadioButton(isSelected: self.isSelected)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var radioButtonImageView: UIImageView = {
        let imageView = UIImageView(image: deselectedImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    public override var intrinsicContentSize: CGSize {
        let width = radioButtonImageView.intrinsicContentSize.width
        + descriptionLabel.intrinsicContentSize.width
        + imagePadding.offset
        let height = radioButtonImageView.intrinsicContentSize.height
        return CGSize(width: width, height: height)
    }
    
    public init(index: Int, title: String) {
        self.index = index
        super.init(frame: .zero)
        descriptionLabel.text = title
        layoutUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func toggleRadioButton(isSelected: Bool) {
        radioButtonImageView.image = isSelected ? selectedImage : deselectedImage
    }
    
    private func layoutUI() {
        addSubview(containerButton)
        containerButton.addSubview(radioButtonImageView)
        containerButton.addSubview(descriptionLabel)
        
        
        radioButtonImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(radioButtonImageView.snp.trailing).offset(imagePadding.offset)
            make.centerY.equalToSuperview()
        }
        
        containerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

public extension SelectableTextRadioButtonView {
    enum ImagePadding {
        case medium
        case large
        
        var offset: CGFloat {
            switch self {
            case .medium:
                return 17.0
            case .large:
                return 26.0
            }
        }
    }
}
