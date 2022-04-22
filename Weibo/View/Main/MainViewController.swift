//
//  MainViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/21.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController()
        setupComposedButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.bringSubviewToFront(composedButton)
    }
    
    // MARK: - 懒加载控件
    private lazy var composedButton: UIButton = UIButton(
        imageName: "tabbar_compose_orange",
        bgImageName: "")
//    private lazy var composedButton: UIButton {
//        let button = UIButton()
//        button.setImage(UIImage(named: "tabbar_compose_orange"), for: UIControl.State.normal)
//        button.setImage(UIImage(named: ""), for: UIControl.State.highlighted)
//        button.setBackgroundImage(UIImage(named: ""), for: UIControl.State.normal)
//        button.setBackgroundImage(UIImage(named: ""), for: UIControl.State.highlighted)
//        button.sizeToFit()
//        return button
//    } ()
}

// MARK: -设置界面
extension MainViewController {
    // 设置新建微博按钮
    private func setupComposedButton() {
        //  1. 添加按钮
        tabBar.addSubview(composedButton)
        
        // 2. 调整按钮
        let count = children.count
        let w = tabBar.bounds.width / CGFloat(count)
        composedButton.frame = CGRect.init(x: w * 2, y: -15, width: w, height: w)
    }
 
    
    private func addChildViewController() {
        // 如果能用颜色解决 不建议使用图片
        tabBar.tintColor = UIColor.orange
        
        addChildViewController(vc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageViewController(), title: "消息", imageName: "tabbar_message")
        addChildViewController(vc: UIViewController(), title: "", imageName: "")
        addChildViewController(vc: DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileViewController(), title: "我的", imageName: "tabbar_profile")
        
    }
    
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        let vc = HomeViewController()
        // 由内至外设置 vc -> nav/navbar
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        
        let navc = UINavigationController(rootViewController: vc)
        addChild(navc)
    }
}