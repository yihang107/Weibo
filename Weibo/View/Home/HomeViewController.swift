//
//  HomeViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/21.
//

import UIKit
import SVProgressHUD

private let StatusCellNormalId = "StatusCellNormalId"
class HomeViewController: VisitorViewController {
    
    /// 微博数据列表模型
    private lazy var listViewModel = StatusListViewModel()
    
    ///微博数据
    var dataList: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogin {
            visitorView?.setupInfo(imageName: "visitor_message", title: "关注一些人, 回这里看看有什么惊喜")
            return
        }
        prepareTableView()
        loadData()
    }
    
    /// 准备表格
    private func prepareTableView() {
        // 注册可重用cell
        tableView.register(StatusCell.self, forCellReuseIdentifier: StatusCellNormalId)
        
        // 预估行高 需要一个自上而下的自动布局的控件 指定向下的约束即可
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    /// 加载数据
    private func loadData() {
        listViewModel.loadStatus { isSuccessed in
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误, 请稍后再试")
                return
            }
            
            self.tableView.reloadData()
        }
    }
}

// MARK: -数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellNormalId, for: indexPath) as! StatusCell
//        cell.textLabel?.text = listViewModel.statusList[indexPath.row].status.text
        cell.viewModel = listViewModel.statusList[indexPath.row]
        return cell
    }
}
