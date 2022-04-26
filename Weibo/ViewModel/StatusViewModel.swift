//
//  StatusViewModel.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//


import UIKit
/// 处理单条微博业务逻辑
class StatusViewModel: CustomStringConvertible {
    /// 微博的模型
    var status: Status
    
    /// 行高
    lazy var rowHeight: CGFloat = {
//        let cell = StatusCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: StatusCellNormalId)
        let cell = StatusRetweetedCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: StatusCellRetweetedId)
        return cell.rowHeight(vm: self)
    } ()
    
    /// 用户头像 URL
    var userProfileUrl: URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    
    /// 默认图片
    var userDefaultIconView: UIImage {
        return UIImage(named: "welcome_head")!
    }
    
    ///
    var statusPicDefaultIconView: UIImage {
        return UIImage(named: "status_404")!
    }
    
    /// 缩略图URL数组 存储性属性
    var thumbnailUrls: [URL]?
    
    init(status: Status) {
        self.status = status
        
        // 生成缩略图数组  要么是转发微博的图片 要么是本身视图的图片
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnailUrls = [URL]()
            
            // 数组如果可选 不允许遍历
            for dic in urls {
                let url = URL(string: dic["thumbnail_pic"]!)
                thumbnailUrls?.append(url!)
            }
        }
    }
    
    var description: String {
        return status.description + "配图数据 \(thumbnailUrls ?? [] as Array)"
    }
}
