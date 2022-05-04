//
//  PhotoBrowserAnimation.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/4.
//

import UIKit

// MARK: 展现的动画协议
protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView
    
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect
    
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect
}

// MARK: 消息动画的协议
protocol PhotoBrowserDismissDeleagte: NSObjectProtocol {
    
    func imageViewForDismiss() -> UIImageView
    
    func indexPathForDismiss() -> IndexPath
    
}


/// 提供转场动画的代理
class PhotoBrowserAnimation: NSObject, UIViewControllerTransitioningDelegate {
    /// 展现代理
    weak var presentDelegate: PhotoBrowserPresentDelegate?
    /// 解除代理
    weak var dismissDelegate: PhotoBrowserDismissDeleagte?
    /// 动画图像的索引
    var indexPath: IndexPath?
    
    /// 是否modal展现
    private var isPresent = false
    
    /// 设置代理参数
    func setDelegateParams(presentDelegate: PhotoBrowserPresentDelegate,
                           indexPath: IndexPath,
                           dismissDeleagte: PhotoBrowserDismissDeleagte) {
        
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDeleagte
        self.indexPath = indexPath
    }
    
    // 返回modal展现的动画对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    // 返回dismiss的动画对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

// MARK: UIViewControllerAnimatedTransitioning
// 实现具体的动画方法
extension PhotoBrowserAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /// 实现具体的动画效果
    /*
     容器视图 UITransitionView 要展现的视图包装在容器视图中 需要自己指定大小
     viewControllerForKey: FromVC / ToVC
     completeTransition 无论转场是否被取消 都必须调用
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimation(using: transitionContext)
        } else {
            dismissAnimation(using: transitionContext)
        }
        
    }
    
    /// 展现动画
    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let delegate = presentDelegate, let ip = indexPath else {
            return
        }
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        let iv = delegate.imageViewForPresent(indexPath: ip)
        iv.frame = delegate.photoBrowserPresentFromRect(indexPath: ip)
        transitionContext.containerView.addSubview(iv)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.alpha = 1
            iv.frame = delegate.photoBrowserPresentToRect(indexPath: ip)
        } completion: { _ in
            iv.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    ///  消失动画
    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate, let dismissDeleagte = dismissDelegate else {
            return
        }
        
        let fromView = transitionContext.view(forKey: .from)!
        fromView.removeFromSuperview()
        
        let iv = dismissDeleagte.imageViewForDismiss()
        transitionContext.containerView.addSubview(iv)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: dismissDeleagte.indexPathForDismiss())
        } completion: { _ in
            iv.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}


