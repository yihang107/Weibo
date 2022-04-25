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
    
    /// 自动填充用户名和密码 以代码的方式向web页面添加内容
    @objc private func autoFill() {
//        let js = "document.getElementById('loginName').value = '17702348271';" + "document.getElementById('loginPassword').value = '111111yy'";
        let js = "document.getElementById('loginName').value = '15060002778';" + "document.getElementById('loginPassword').value = '15060002778'";
        // 让webView执行js
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.autoFill))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开发中 如果用纯代码开发 视图最好都指定背景颜色 如果为nil 影响渲染效率
//        view.backgroundColor = UIColor.white
        
        // 加载页面
        self.webView.load(URLRequest(url: YYHNetworkTools.sharedTools.oAuthURL))
    }
}


//MARK: WKWebviewDelegate


extension OAuthViewController: WKNavigationDelegate {
    /// 收到响应之后 是否允许加载
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        guard let url = navigationResponse.response.url, url.host == "api.weibo.com/oauth2/default.html" else {
        guard let url = navigationResponse.response.url, url.host == "www.sina.com" else {
            decisionHandler(WKNavigationResponsePolicy.allow)
            return
        }
        
        // 从重定向地址提取code是否存在
        guard let query = url.query, query.hasPrefix("code=") else {
            decisionHandler(WKNavigationResponsePolicy.cancel)
            return
        }
        
        
        // 提取code=后面的授权码
//        print(url.host!)
//        print(url.query!)
        let code = query.substring(from: "code=".endIndex)
        print("授权码是:" + code)
        
        // 加载accessToken
        UserAccountViewModel.sharedUserAccount.loadAccessToken(code: code) { isSuccessed in
            if isSuccessed {
                print("access获取成功")
            } else {
                print("access获取失败")
            }
        }
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
}
