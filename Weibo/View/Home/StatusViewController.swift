//
//  StatusViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/6.
//

import UIKit
import WebKit

class StatusViewController: UIViewController, WKNavigationDelegate {
    // MARK: 初始化
    init(statusId: Int) {
        status_id = statusId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 生命周期
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(URLRequest(url: YYHNetworkTools.sharedTools.urlForSingleStatus(status_id: status_id)))
    }

    private let status_id: Int
    private lazy var webView = WKWebView()
}
