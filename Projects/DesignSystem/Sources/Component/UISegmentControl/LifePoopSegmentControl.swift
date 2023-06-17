//
//  LifePoopSegmentControl.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import SnapKit

public class LifePoopSegmentControl: UIControl {
    
    private var buttons: [UIButton] = []
    private lazy var backgroundButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.backgroundColor = ColorAsset.gray200.color
        stackView.layer.cornerRadius = 22
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let selectedSegmentView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorAsset.primary.color
        view.layer.cornerRadius = 22
        return view
    }()
    
    private var titleLabels: [UILabel] = []
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: titleLabels)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private var titles: [String] = []
    private let deselectedTitleColor = ColorAsset.gray800.color
    private let selectedTitleColor = ColorAsset.white.color
    private let animatingDuration: Double = 0.3
    
    public internal(set) var selectedSegmentIndex: Int?
    
    private var selectableSegmentCount: Int {
        return titles.count
    }
    
    public func setTitles(_ titles: [String]) {
        self.titles = titles
        configureUI(with: titles)
        layoutUI()
    }
    
    public func selectSegment(at targetIndex: Int) {
        guard 0..<selectableSegmentCount ~= targetIndex else { return }
        let latestSelectedSegmentIndex = selectedSegmentIndex
        selectedSegmentIndex = targetIndex
        
        changeTitleColor(selectAt: targetIndex, deselectAt: latestSelectedSegmentIndex)
        
        if let latestSelectedSegmentIndex {
            moveSelectedSegmentView(from: latestSelectedSegmentIndex, to: targetIndex)
        } else {
            layoutSelectedSegmentView(to: targetIndex)
        }
        
        sendActions(for: .valueChanged)
    }
}

// MARK: - Animating Methods

private extension LifePoopSegmentControl {
    func moveSelectedSegmentView(from latestSelectedIndex: Int, to index: Int) {
        UIView.animate(withDuration: animatingDuration) {
            self.selectedSegmentView.frame.origin.x = self.buttons[index].frame.origin.x
        }
    }
    
    func changeTitleColor(selectAt selectedIndex: Int, deselectAt deselectedIndex: Int?) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.duration = animatingDuration
        
        if let deselectedIndex {
            self.titleLabels[deselectedIndex].layer.add(transition, forKey: CATransitionType.fade.rawValue)
            self.titleLabels[deselectedIndex].textColor = self.deselectedTitleColor
        }
        self.titleLabels[selectedIndex].layer.add(transition, forKey: CATransitionType.fade.rawValue)
        self.titleLabels[selectedIndex].textColor = self.selectedTitleColor
    }
}

// MARK: - Supporting Methods

private extension LifePoopSegmentControl {
    func appendLabel(with text: String?) {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = deselectedTitleColor
        titleLabels.append(label)
    }
    
    func appendButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        buttons.append(button)
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        for (index, selectedButton) in buttons.enumerated() where selectedButton == sender {
            selectSegment(at: index)
        }
    }
}

// MARK: - UI Configuration

private extension LifePoopSegmentControl {
    func configureUI(with titles: [String]) {
        titles.forEach { title in
            appendButton()
            appendLabel(with: title)
        }
    }
    
    func layoutUI() {
        addSubview(backgroundButtonStackView)
        addSubview(selectedSegmentView)
        addSubview(titleStackView)
        
        backgroundButtonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutSelectedSegmentView(to index: Int) {
        selectedSegmentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(snp.width).multipliedBy(1 / CGFloat(selectableSegmentCount))
            make.leading.equalTo(buttons[index])
        }
    }
}
