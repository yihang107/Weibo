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
        window?.rootViewController = NewFeatureCollectionViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    /// 设置全局外观 在很多应用程序中 都会在Appdelegate中设置所有需要控件的内部设置
    private func setupAppearance() {
        // 修改导航栏的全局外观 要在控件创建之前设置 一经设置 全局有效
        UINavigationBar.appearance().tintColor = WBAppearanceTintColor
        UITabBar.appearance().tintColor = WBAppearanceTintColor
    }
}

