//
//  StatusListViewModel.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import Foundation
import SDWebImage

/// 微博数据列表模型 - 封装网络方法
class StatusListViewModel {
    /// 微博数据数组 -上拉/下拉 刷新
    lazy var statusList = [StatusViewModel]()
    
    /// 加载数据
    func loadStatus(isPullup: Bool, finished: @escaping(_ isSuccessed: Bool)->()) {
        // 下拉刷新
        let since_id = isPullup ? 0 : statusList.first?.status.id ?? 0
        // 上拉刷新
        let max_id = isPullup ? statusList.last?.status.id  ?? 0 : 0
        
        // 获取数据 从本地缓存或者网络
        StatusDAL.loadStatus(since_id: since_id, max_id: max_id) { array in
            if array == nil {
                finished(false)
            }
            
            var dataList = [StatusViewModel]()
            for dic in array! {
                dataList.append(StatusViewModel(status: Status(dict: dic)))
            }
            
            if isPullup {
                self.statusList = self.statusList + dataList
            } else {
                self.statusList = dataList + self.statusList
            }
            
            self.statusList = YYHNetworkTools.sharedTools.fakeStashStatus + self.statusList
//            print(self.statusList)
            
            // 缓存单张图片
            self.cacheSingleImage(dataList: dataList, finished: finished)
        }
    }
    
    /// 缓存所有单张图片的微博的图片
    private func cacheSingleImage(dataList: [StatusViewModel], finished: @escaping(_ isSuccessed: Bool)->()) {
        let group = DispatchGroup()
        // 遍历
        for vm in dataList {
//            print(vm)
            if vm.thumbnailUrls?.count != 1 {
                continue
            }
            
            let url = vm.thumbnailUrls![0]
            // 入组
            group.enter()
            // 如果设置了retryFailed, 整个block会结束一次, 会做一次出组
            // SDWebImage会重新执行下载, 下载完成后, 再次调用block中的代码
            // 再次出组, 造成调度组的不匹配
            // refreshCached 第一次发器玩过请求, 把缓存图片的一个hash值发送给服务器
            // 服务器比对hash，如果和服务器内容一致, 服务器的状态码304, 表示服务器内容没有变化
            // 不是304会再次发起网络请求，获取更新后的内容
            SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, _, _, _, _, _ in
                // 单张图片下载完成
                group.leave()
            }
        }
        
        // 应该使用主队列开启回调
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: {
            print("缓存完成")
            // 完成回调 控制器才开始刷新表格
            finished(true)
        }))
    }
}
