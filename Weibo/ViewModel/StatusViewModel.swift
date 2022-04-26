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
    
    /// cell的可重用标识符号
    var cellId: String {
        return status.retweeted_status != nil ? StatusCellRetweetedId : StatusCellNormalId
    }
    
    
    /// 行高
    lazy var rowHeight: CGFloat = {
        var statusCell: StatusCell
        if self.status.retweeted_status != nil {
            statusCell = StatusRetweetedCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: StatusCellRetweetedId)
        } else {
            statusCell = StatusNormalCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: StatusCellNormalId)
        }
        return statusCell.rowHeight(vm: self)
    } ()
    
    /// 用户头像 URL
    var userProfileUrl: URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    
    /// 头像默认图片
    var userDefaultIconView: UIImage {
        return UIImage(named: "welcome_head")!
    }
    
    /// 微博
    var statusPicDefaultIconView: UIImage {
        return UIImage(named: "status_404")!
    }
    
    /// 缩略图URL数组 存储性属性
    var thumbnailUrls: [URL]?
    
    /// 转发微博文字
    var retweetedText: String? {
        guard let s = status.retweeted_status else {
            return nil
        }
        return "@\(s.user?.screen_name ?? "")" + ":\(s.text ?? "")" 
    }
    
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
