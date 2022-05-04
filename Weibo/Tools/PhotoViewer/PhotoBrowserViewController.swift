//
//  PhotoBrowserViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/3.
//

import UIKit
import SwiftUI
import SVProgressHUD

/// 可重用cell标识符号
private let PhotoBrowserCellId = "PhotoBrowserCellId"

class PhotoBrowserViewController: UIViewController {
    private var urls: [URL]
    private var currentIndexPath: NSIndexPath
    
    // MARK: 监听方法
    @objc private func close() {
//        print("关闭")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
//        print("保存")
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCollectionViewCell
        // 因为网络问题没有图片
        guard let image = cell.imageView.image else {
            return
        }
        
        // 保存图片
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSvaingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSvaingWithError error: NSError?, contextInfo: Any?) {
        if error != nil {
            SVProgressHUD.showInfo(withStatus: "保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
        
    }
    
    // MARK: 构造函数
    init (urls: [URL], indexPath: NSIndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 生命周期
    // 和xib和sb等价 主要职责创建视图层次结构 loadView执行完毕 view上的元素要全部创建完成
    // 如果view == nil 系统会在调用view的getter方法时, 自动调用loadView 创建view
    override func loadView() {
        // 设置根视图
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        self.setupUI()
    }
    
    // 视图加载完成被调用 loadView执行完毕被执行
    // 主要做数据加载 或其他处理
    // 常见没有实现loadView， 所有建立子控件的代码都在viewDidLoad中
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: 懒加载控件
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowerViewLayout())
    private lazy var closeButton: UIButton = UIButton(title: "关闭", color: UIColor.white, bgColor: UIColor.darkGray)
    private lazy var saveButton: UIButton = UIButton(title: "保存", color: UIColor.white, bgColor: UIColor.darkGray)
    
    // MARK: 自定义layout
    private class PhotoBrowerViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
        }
    }
}

// MARK: 设置UI
private extension PhotoBrowserViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        collectionView.frame = view.bounds
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.left.equalTo(view.snp.left).offset(20)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.right.equalTo(view.snp.right).offset(-40)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        closeButton.addTarget(self, action: #selector(self.close), for: UIControl.Event.touchUpInside)
        saveButton.addTarget(self, action: #selector(self.save), for: UIControl.Event.touchUpInside)
        
        prepareCollectionView()
        
    }
    
    /// 准备 collectionView
    private func prepareCollectionView() {
        collectionView.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellId)
        collectionView.dataSource = self
    }
 }


// MARK: 数据源
extension PhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellId, for: indexPath) as! PhotoBrowserCollectionViewCell
        cell.backgroundColor = UIColor.black
        cell.imageURL = urls[indexPath.item]
        cell.photoBrowserCellDelegate = self
        return cell
    }
}



// MARK: PhotoBrowserCollectionViewCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCollectionViewCellDelegate {
    func photoBrowserCellDidTapImage() {
        close()
    }
}

// MARK: 解除转场动画协议
extension PhotoBrowserViewController: PhotoBrowserDismissDeleagte {
    func imageViewForDismiss() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCollectionViewCell
        iv.image = cell.imageView.image
        iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        
//        UIApplication.shared.keyWindow?.addSubview(iv)
        return iv
    }
    
    func indexPathForDismiss() -> IndexPath {
        return collectionView.indexPathsForVisibleItems[0]
    }
}
