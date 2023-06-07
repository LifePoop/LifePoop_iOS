//
//  LoginViewController.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class LoginViewController: UIViewController, ViewType {
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = ColorAsset.primary.color
        pageControl.pageIndicatorTintColor = ColorAsset.gray300.color
        return pageControl
    }()
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: BannerImageCell.identifier)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = ColorAsset.pooBlack.color
        label.text = "나의 변을 기록하고"
        return label
    }()
    
    private let kakaoTalkLoginButon = LoginButton(
        title: "카카오로 계속하기",
        backgroundColor: ColorAsset.pooYellow.color,
        fontColor: ColorAsset.pooBrown.color,
        iconImage: ImageAsset.iconKakao.image
    )
    
    private let appleLoginButton = LoginButton(
        title: "Apple로 계속하기",
        backgroundColor: ColorAsset.black.color,
        fontColor: ColorAsset.white.color,
        iconImage: ImageAsset.iconApple.image
    )
    
    public var viewModel: LoginViewModel?
    private var disposeBag = DisposeBag()

    private let bannerImages = [
        ImageAsset.bannerFirst.image.pngData(),
        ImageAsset.bannerSecond.image.pngData(),
        ImageAsset.bannerThird.image.pngData()
    ]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        
        viewModel?.output.bannerImages.accept(bannerImages.compactMap { $0 })
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public func bindInput(to viewModel: LoginViewModel) {
        let input = viewModel.input
        
        kakaoTalkLoginButon.rx.tap
            .bind(to: input.didTapKakaoLoginButton)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .bind(to: input.didTapAppleLoginButton)
            .disposed(by: disposeBag)
        
        let pageControlIndex = bannerCollectionView.rx.didScroll
            .withUnretained(self)
            .filter { `self`, _ in
                self.bannerCollectionView.bounds.width > 0
            }
            .withUnretained(self)
            .map { `self`, _ in
                let width = self.bannerCollectionView.bounds.size.width
                let xValue = self.bannerCollectionView.contentOffset.x + (width/2.0)
                let newPage = Int(xValue/width)
                return newPage
            }
            .share()
        
        pageControlIndex
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        pageControlIndex
            .bind(to: input.didChangeBannerImageIndex)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: LoginViewModel) {
        let output = viewModel.output
        
        output.bannerImages
            .map { $0.count }
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        output.bannerImages
            .bind(to: bannerCollectionView.rx.items(
                cellIdentifier: BannerImageCell.identifier,
                cellType: BannerImageCell.self)
            ) { _, imageData, cell in
                
                cell.configure(imageData: imageData)
            }
            .disposed(by: disposeBag)
        
        output.subLabelText
            .bind(to: subLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .bind(onNext: { error in
                print("\(error) 확인 -> 추후 확인 후 토스트 메시지 혹은 다른 시각적 요소 출력으로 대체")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension LoginViewController {
    func layoutUI() {
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width

        view.addSubview(bannerCollectionView)
        view.addSubview(subLabel)
        view.addSubview(pageControl)
        view.addSubview(kakaoTalkLoginButon)
        view.addSubview(appleLoginButton)

        bannerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(frameHeight*0.07)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(frameWidth*0.8)
        }

        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bannerCollectionView.snp.bottom).offset(frameHeight*0.03)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(frameHeight*0.03)
            make.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(frameHeight*0.05)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        kakaoTalkLoginButon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-frameHeight*0.01)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
}
