//
//  StatusPictureView.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/26.
//

import UIKit
import SDWebImage

private let StatusPictureViewItemMargin: CGFloat = 8
private let StatusPictureCellId = "StatusPictureCellId"
class StatusPictureView: UICollectionView {
    var viewModel: StatusViewModel? {
        didSet {
            sizeToFit()
            // 如果不刷新 后续的collectionView一旦被复用, 不再调用数据源方法
            reloadData()
        }
    }
    // MARK: 构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = StatusPictureViewItemMargin
        layout.minimumInteritemSpacing = StatusPictureViewItemMargin
        // 默认itemsize 50*50
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
//        backgroundColor = UIColor.red
        
        // 设置数据源
        dataSource = self
        delegate = self
        
        // 注册可重用cell
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureCellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return cellViewSize()
    }
}

//MARK: 计算视图大小
extension StatusPictureView {
    /// 计算视图大小
    private func cellViewSize() -> CGSize {
        let rowCount = 3.0
        let maxWidth = UIScreen.main.bounds.width - 2 * StatusCellMargin
        let itemWidth = (maxWidth - 2 * StatusPictureViewItemMargin) / rowCount
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let count = viewModel?.thumbnailUrls?.count ?? 0
        
        if count == 0 {
            return CGSize(width: 0, height: 0)
        }
        
        if  count == 1 {
            // 利用SDWebImage 检查本地的缓存图像
            var size = CGSize(width: 150, height: 120)
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString {
                // 这里异步查找图片？
                // SDWebImage 设置文件名 完整URL字符串 MD5
                SDWebImageManager.shared.imageCache.queryImage(forKey: key,
                                                               options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed],
                                                               context: nil) { image, _, _ in
                    if let img = image {
                        size = img.size
                        layout.itemSize = size
                        
                        // 过窄处理 - 针对长图
                        size.width = size.width < 40 ? 40 : size.width
                        
                        // 过宽图片
                        if size.width > 300 {
                            let w: CGFloat = 300
                            let h = size.height * w / size.width
                            size = CGSize(width: w, height: h)
                        }
                    }
                }
                
            }
            
            layout.itemSize = size
            return size
        }
        
        if count == 4 {
            let w = 2 * itemWidth + StatusPictureViewItemMargin
            return CGSize(width: w, height: w)
        }
        
        // 9宫格
        let row = CGFloat((count - 1) / Int(rowCount)  + 1)
        let h = row * itemWidth + (row - 1) * StatusPictureViewItemMargin
        let w = rowCount * itemWidth + (rowCount - 1) * StatusPictureViewItemMargin
        
        return CGSize(width: w, height: h)
    }
}

// MARK: 数据源和代理
extension StatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(viewModel?.thumbnailUrls?.count ?? 0)
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPictureCellId, for: indexPath) as! StatusPictureViewCell
//        cell.backgroundColor = UIColor.orange
        cell.imageURL = viewModel!.thumbnailUrls![indexPath.item]
        return cell
    }
    
    /// 选中照片
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击照片")
        // 传给用户当前URL数组 当前索引
        let userInfo = [WBStatusSelectedPhotoIndexPathKey: indexPath,
                             WBStatusSelectedPhotoURLsKey: viewModel!.thumbnailUrls!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(WBStatusSelectPhotoNotification),
                                        object: self,
                                        userInfo: userInfo)
    }
}


private class StatusPictureViewCell: UICollectionViewCell {
    var imageURL: URL? {
        didSet {
            //retryfailed 失败重试 不设置15s超时后进入黑名单 不再下载
            //refreshCached URl不变 服务器图像变了 搞新的图像
            //调用OC框架的时候 可选项设置不严格
//            print(imageURL!)
//            iconView.image = UIImage(named: "status_404")
            iconView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "status_404"), options: [SDWebImageOptions.allowInvalidSSLCertificates, SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached], context: nil)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加控件
        contentView.addSubview(iconView)
        // 设置布局 因为cell会变化 不同的cell大小不一样 所以使用自动布局
//        iconView.frame = contentView.bounds
        iconView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.top.equalTo(contentView.snp.top)
        }
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
    }
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
}
