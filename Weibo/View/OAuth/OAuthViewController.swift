//
//  OAuthViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/23.
//

import UIKit
import WebKit

/// 用户登录控制器
class OAuthViewController: UIViewController {
    private lazy var webView = WKWebView()
    
    // MARK: 监听方法
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        view = webView
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.close))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开发中 如果用纯代码开发 视图最好都指定背景颜色 如果为nil 影响渲染效率
//        view.backgroundColor = UIColor.white
        
        // 加载页面
        self.webView.load(URLRequest(url: YYHNetworkTools.sharedTools.oAuthURL))
    }
}
