//
//  HomeViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/21.
//

import UIKit
import SVProgressHUD

let StatusCellNormalId = "StatusCellNormalId"
let StatusCellRetweetedId = "StatusCellRetweetedId"
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
        
        // 注册通知 如果使用通知中心的block监听, 其中的self一定要弱引用
        NotificationCenter.default.addObserver(forName: NSNotification.Name(WBStatusSelectPhotoNotification), object: nil, queue: nil) { [weak self] n in
            guard let indexPath = n.userInfo?[WBStatusSelectedPhotoIndexPathKey] as? NSIndexPath else {
                return;
            }
            
            guard let urls = n.userInfo?[WBStatusSelectedPhotoURLsKey] as? [URL] else {
                return
            }
            print(indexPath)
            print(urls)
            
            let vc = PhotoBrowserViewController(urls: urls, indexPath: indexPath)
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 准备tablview
    private func prepareTableView() {
        // 注册可重用cell
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusCellNormalId)
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: StatusCellRetweetedId)
        // 预估行高 需要一个自上而下的自动布局的控件 指定向下的约束即可
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        // 取消分割线
        tableView.separatorStyle = .none
        
        // 下拉刷新控件
        refreshControl = UIRefreshControl()
        
        // 添加监听方法
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: UIControl.Event.valueChanged)
        
        // 上拉刷新视图
        tableView.tableFooterView = pullupView
    }
    
    /// 加载数据
    @objc private func loadData() {
        self.refreshControl?.beginRefreshing()
        listViewModel.loadStatus(isPullup: pullupView.isAnimating) { isSuccessed in
            // 关闭下拉刷新
            self.refreshControl?.endRefreshing()
            self.pullupView.stopAnimating()
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误, 请稍后再试")
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: 懒加载控件
    private lazy var pullupView: UIActivityIndicatorView = {
        let indivator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        return indivator
    }()
}

// MARK: -数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 会调用行高方法
        let vm = listViewModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellId, for: indexPath) as! StatusCell
        cell.viewModel = vm
        
        // 上拉刷新数据
        if indexPath.row == listViewModel.statusList.count - 1 && !pullupView.isAnimating && listViewModel.statusList.count != 0 {
            pullupView.startAnimating()
            loadData()
        }
        return cell
    }
    
    /// 行高计算原理
    /*
     调用次数
     设置了预估行高 每个cell调用3次 每个版本XCode次数kennel不同
     
     没有设置预估行高 计算每个cell的高度  计算显示cell的高度
     行数 -> 行高
    
     预估行高不同 计算的次数不同
     预估行高 尽量接近
     
     使用预估行高 计算预估的contentSize
     根据预估行高 判断计算次数 顺序计算每一行的行高 更新ContentSize
     直到显示满
     如果预估行高过大 超出预估范围 顺序计算后续行高 直到填满屏幕 退出 同时更新contentSize
     使用预估行高 每个cell的显示前需要计算, 单个cell的效率是低的, 从而整体效率高
     
     为什么要调用所有行高方法
     UTTableView 继承自 UIScrollView
     表格视图滚动非常流畅 需要提前计算contentSize
     
     如果行高是固定值 不要实现行高代理方法
     
     实际开发中 行高一定要缓存
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
//        if vm.rowHeight != nil {
//            return vm.rowHeight!
//        }
//
//        let cell = StatusCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: StatusCellNormalId)
//        vm.rowHeight = cell.rowHeight(vm: vm)
//        return cell.rowHeight(vm: vm)
        return vm.rowHeight
    }
}

// MARK: delegate
extension HomeViewController{
    /// 选中微博
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
