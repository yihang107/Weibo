//
//  VisitorViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/22.
//

import UIKit

class VisitorViewController: UITableViewController {
    /// 用户登陆标记
    private var userLogin = false
    /// 访客视图
    var visitorView: VisitorView?
    override func loadView() {
        // 根据用户登陆情况决定显示的根视图
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        super.loadView()
        visitorView = VisitorView()
        view = visitorView
//        view.backgroundColor = UIColor.orange
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil, title: "关注一些人, 回这里看看有什么事")
    }

//    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

}
