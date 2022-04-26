//
//  StatusListViewModel.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import Foundation


/// 微博数据列表模型 - 封装网络方法
class StatusListViewModel {
    /// 微博数据数组 -上拉/下拉 刷新
    lazy var statusList = [StatusViewModel]()
    
    /// 加载数据
    func loadStatus(finished: @escaping(_ isSuccessed: Bool)->()) {
        YYHNetworkTools.sharedTools.loadStatus { result, error in
            if error != nil {
                print("主页微博数据请求出错")
                return
            }
            
//            print(result!)
            guard let newResult = result as? [String: Any] else{
                print("数据格式错误")
                finished(false)
                return
            }
            
            guard let array = newResult["statuses"] as? [[String: AnyObject]] else {
                print("数据格式错误")
                finished(false)
                return
            }
            
            var dataList = [StatusViewModel]()
            for dic in array {
                dataList.append(StatusViewModel(status: Status(dict: dic)))
            }
            
            self.statusList = dataList + self.statusList
            print(self.statusList)
            finished(true)
        }
    }
}
