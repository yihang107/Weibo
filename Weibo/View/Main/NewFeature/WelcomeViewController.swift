//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    /// 设置界面 视图结构层次
    override func loadView() {
        // 直接使用背景图片作为根视图 不用关心图片的缩放
        view = bgImageView
        setupUI()
    }
    
    /// 视图加载完成后的后续处理 设置处理
    override func viewDidLoad() {
        super.viewDidLoad()
        iconView.sd_setImage(with: UserAccountViewModel.sharedUserAccount.avatarUrl, placeholderImage: UIImage(named: "welcome_head"), options: SDWebImageOptions.continueInBackground, context: nil)
    }
    
    /// 视图已经显示 设置动画
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 动画
        // 更新以及设置过的约束
        /*
         自动布局开发约束设置位置的控件 不再设置frame
         自动布局会根据设置的约束 自动计算控件的frame
         如果程序员主动修改frame， 会引起自动布局计算错误
         当有一个runloop启动后, 自动布局系统会收集所有约束变化
         在运行循环结束前 调用layoutsubview函数统一设置frame
         如果希望某些约束提前更新 使用layoutifneed 让自动布局系统, 提前更新收集到的约束变化
         */
        welcomeLabel.alpha = 0;
        iconView.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 350)
        }
        
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.welcomeLabel.alpha = 1
            } completion: { _ in
                NotificationCenter.default.post(name: NSNotification.Name(WBSwitchRootViewControllerNotification), object: nil)
            }

        }

    }
    
    // MARK: -懒加载控件
    private lazy var bgImageView: UIImageView = UIImageView(imgName: "welcome_bg")
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(imgName: "welcome_head")
        iconView.layer.cornerRadius = 45
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    private lazy var welcomeLabel: UILabel = UILabel(title: "欢迎归来", fontSize: 20, color: UIColor.darkGray)
}

// MARK: -设置图片
extension WelcomeViewController {
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-250)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
        
    }
}
