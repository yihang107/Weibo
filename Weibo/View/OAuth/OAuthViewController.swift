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
        let js = "document.getElementById('loginName').value = '17702348271';" + "document.getElementById('loginPassword').value = '111111yy'";
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
        YYHNetworkTools.sharedTools.loadAccessToken(code: code) { result, error in
//            if error != nil {
//                print("没有获取到accessToken")
//                return
//            }
        
            print(result ?? "没有accessToken结果")
//            let account = UserAccount(dict: result as! [String : Any]) "uid": "1404376560", "expires_in": 157679999,
            let account = UserAccount.init(dict: ["access_token": "fadsf", "uid": "1404376560", "expires_in": 157679999])
            self.loadUserInfo(account: account)
        }
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    
    private func loadUserInfo(account: UserAccount) {
        YYHNetworkTools.sharedTools.loadUserInfo(uid: account.uid!, accessToken: account.access_token!) { result, error in
//            if error != nil {
//                print("加载用户出错")
//                return
//            }
//            
//            guard let dict = result as? [String : Any] else {
//                print("用户信息格式错误")
//                return
//            }
            
            let dict1 = [
                "id": 1404376560,
                "screen_name": "zaku",
                "name": "zaku",
                "province": "11",
                "city": "5",
                "location": "北京 朝阳区",
                "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
                "url": "http://blog.sina.com.cn/zaku",
                "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
                "domain": "zaku",
                "gender": "m",
                "followers_count": 1204,
                "friends_count": 447,
                "statuses_count": 2908,
                "favourites_count": 0,
                "created_at": "Fri Aug 28 00:00:00 +0800 2009",
                "following": false,
                "allow_all_act_msg": false,
                "geo_enabled": true,
                "verified": false,
                "status": [
                    "created_at": "Tue May 24 18:04:53 +0800 2011",
                    "id": 11142488790,
                    "text": "我的相机到了。",
                    "source": "<a href='http://weibo.com' rel='nofollow'>新浪微博</a>",
                    "favorited": false,
                    "truncated": false,
                    "in_reply_to_status_id": "",
                    "in_reply_to_user_id": "",
                    "in_reply_to_screen_name": "",
                    "geo": nil,
                    "mid": "5610221544300749636",
                    "annotations": [],
                    "reposts_count": 5,
                    "comments_count": 8
                ],
                "allow_all_comment": true,
                "avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
                "verified_reason": "",
                "follow_me": false,
                "online_status": 0,
                "bi_followers_count": 215
            ] as [String : Any]
            
            // 将用户信息保存
            account.screen_name = dict1["screen_name"] as? String
            account.avatar_large = dict1["avatar_large"] as? String
            print(account)
            account.saveUserAccount()
        }
    }
}
