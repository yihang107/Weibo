//
//  NewFeatureCollectionViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit

private let NewFeatureViewCellId = "NewFeatureViewCellId"
private let NewFeatureImageCount = 4

class NewFeatureCollectionViewController: UICollectionViewController {
    // MARK: -构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureViewCellId)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: -UICollectionViewDataSource
    // 每个分组中格子的数量
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewFeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureViewCellId, for: indexPath) as! NewFeatureCell
        cell.imageIndex = indexPath.item
        return cell
    }

    // MARK: -UICollectionViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page != NewFeatureImageCount - 1 {
            return
        }
        
       let cell =  collectionView?.cellForItem(at: IndexPath.init(item: page, section: 0)) as! NewFeatureCell
        cell.showButtonAnimation()
    }
}


// MARK: 新特性Cell
private class NewFeatureCell: UICollectionViewCell {
    var imageIndex: Int = 0 {
        didSet {
            iconView.contentMode = .scaleAspectFit
            iconView.image = UIImage(named: "new_feature_\(imageIndex)")
            startButton.isHidden = true
//            showButtonAnimation()
        }
    }
    
    /// 点击开始体验
    @objc private func clickStartBtn() {
        window?.rootViewController = MainViewController()
        NotificationCenter.default.post(name: NSNotification.Name(WBSwitchRootViewControllerNotification), object: nil)
    }
    
    /// 显示按钮动画
    func showButtonAnimation() {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        self.startButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut) {
            self.startButton.transform = CGAffineTransform.identity
        } completion: { finish in
            self.startButton.isUserInteractionEnabled = true
        }

    }
    
    // frame的大小是 layout.itemSize指定的
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        // 添加控件
        addSubview(iconView)
        addSubview(startButton)
        // 指定位置
        iconView.frame = bounds
//        iconView.backgroundColor = UIColor.yellow
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-100)
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
        
        startButton.addTarget(self, action: #selector(self.clickStartBtn), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
    /// 开始体验按钮
    private lazy var startButton: UIButton = UIButton(title: "开始体验", color: UIColor.orange)
}
