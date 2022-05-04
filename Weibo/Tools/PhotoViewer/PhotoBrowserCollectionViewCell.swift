//
//  PhotoBrowserCollectionViewCell.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/3.
//

import UIKit
import SDWebImage
import SVProgressHUD

protocol PhotoBrowserCollectionViewCellDelegate: NSObjectProtocol {
    func photoBrowserCellDidTapImage()
}

/// 照片浏览cell
class PhotoBrowserCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    weak var photoBrowserCellDelegate: PhotoBrowserCollectionViewCellDelegate?
    // MARK: 监听方法
    @objc func close() {
        photoBrowserCellDelegate?.photoBrowserCellDidTapImage()
    }
    /*
     手势识别是对 touch的封装。UIScrollView支持捏合手势。做过手势监听的控件, 都会屏蔽掉touch
     */
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return true
//    }
    
    /// 图像地址
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return
            }
            
            resetScrollView()
            
            // 从磁盘加载缩略图的图像
            let placeholder = SDWebImageManager.shared.imageCache.queryImage(forKey: url.absoluteString, options: [], context: nil, completion: nil) as? UIImage
            imageView.image = placeholder
            imageView.sizeToFit()
            imageView.center = scrollView.center
            
            imageView.sd_setImage(with: orginalURL(url: url), placeholderImage: placeholder, options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached]) { current, total, _ in
                
            } completed: { image, _, _, _ in
                if image == nil {
                    SVProgressHUD.showError(withStatus: "您的网络不给力, 请确认网络后重试")
                    return
                }
                self.setPosition(image: image)
            }

//            imageView.sd_setImage(with: orginalURL(url: url)
//            ) { image, _, _, _ in
//                // 自动设置大小
////                self.imageView.sizeToFit()
//                self.setPosition(image: image)
//            }
        }
    }
    
    /// 设置图片位置 长短图
    private func setPosition(image: UIImage?) {
        self.imageView.center = CGPoint.zero
        let size = self.displaySize(image: image)
        
        if size.height < scrollView.bounds.height {
            // 上下居中显示 调整frame的x/y 一旦缩放 影响滚动范围
            let y = (scrollView.bounds.height - size.height) * 0.5
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 内容边距 会调整控件位置 但不影响控件的滚动
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    /// 根据scrollView宽度等比缩放之后的图片尺寸
    private func displaySize(image: UIImage?) -> CGSize {
        guard let img = image else {
            return CGSize(width: 0, height: 0)
        }
        let w = scrollView.bounds.width
        let h = img.size.height / img.size.width * w
        return CGSize(width: w, height: h) }
    
    /// 返回原图URL
    private func orginalURL(url: URL) -> URL {
        let urlString = url.absoluteString
        let orginUrlString = urlString.replacingOccurrences(of: "/thumbnail/", with: "/original/")
        return URL(string: orginUrlString)!
    }
    
    private func resetScrollView() {
        imageView.transform = CGAffineTransform.identity
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        scrollView.backgroundColor = UIColor.black
        
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        tap.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
//        scrollView.addGestureRecognizer(tap)
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
    }
    // MARK: 懒加载控件
    lazy var scrollView: UIScrollView  = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
}

// MARK: UIScrollViewDelegate
extension PhotoBrowserCollectionViewCell: UIScrollViewDelegate {
    /// 返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放后被执行一次
    /*
     view 被缩放的视图
     scale 被缩放的比例
     */
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        print("缩放完成\(view!)\(view?.bounds)")
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    /// 只要缩放就会被调用
    /*
     tx ty 设置位移
     a d 缩放比例
     a b c d 决定旋转
     */
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(imageView.transform)
//    }
}
