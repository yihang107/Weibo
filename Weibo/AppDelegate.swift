//
//  AppDelegate.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultRootViewControll
        window?.makeKeyAndVisible()
        

        // 代理1对1 通知1:多
        NotificationCenter.default.addObserver(forName: NSNotification.Name(WBSwitchRootViewControllerNotification),
                                               object: nil, // 发送通知的对象  如果nil监听任何对象
                                               queue: nil) {[weak self] notification in // queue为nil是主线程上
            let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
            // 切换控制器
            self?.window?.rootViewController = vc
            
        }
        
        return true
    }
    
    deinit {
        // 注销指定通知
        NotificationCenter.default.removeObserver(self, // 监听者
                                                  name: NSNotification.Name(WBSwitchRootViewControllerNotification),
                                                  object: nil) // 发送通知的对象
    }
    
    /// 设置全局外观 在很多应用程序中 都会在Appdelegate中设置所有需要控件的内部设置
    private func setupAppearance() {
        // 修改导航栏的全局外观 要在控件创建之前设置 一经设置 全局有效
        UINavigationBar.appearance().tintColor = WBAppearanceTintColor
        UITabBar.appearance().tintColor = WBAppearanceTintColor
    }
}


// MARK: -界面切换代码
extension AppDelegate {
    private var defaultRootViewControll: UIViewController {
        if UserAccountViewModel.sharedUserAccount.userLogin {
            return isNewVersion ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        
        return MainViewController()
    }
    
    /// 判断是否新版本
    private var isNewVersion: Bool {
        // 当前版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print("当前版本\(currentVersion)")
        
        // 之前的版本 把当前版本保存在用户偏好 如果key不存在 返回0
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersionKey)
        print("之前版本\(sandboxVersion)")
        
        // 保存当前版本
        UserDefaults.standard.set(version, forKey: sandboxVersionKey)
       return version > sandboxVersion
    }
}

