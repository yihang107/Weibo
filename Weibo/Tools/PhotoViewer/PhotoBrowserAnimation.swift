//
//  PhotoBrowserAnimation.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/4.
//

import UIKit

/// 提供转场动画的代理
class PhotoBrowserAnimation: NSObject, UIViewControllerTransitioningDelegate {
    // 是否modal展现
    private var isPresent = false
    
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
        return 1
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
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.alpha = 1
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    ///  消失动画
    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.alpha = 0
        } completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
