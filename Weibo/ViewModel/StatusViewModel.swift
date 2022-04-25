//
//  StatusViewModel.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//


import UIKit
/// 处理单条微博业务逻辑
class StatusViewModel {
    /// 微博的模型
    var status: Status
    
    /// 用户头像 URL
    var userProfileUrl: URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    
    ///
    var userDefaultIconView: UIImage {
        return UIImage(named: "welcome_head")!
    }
    
    init(status: Status) {
        self.status = status
    }
}
