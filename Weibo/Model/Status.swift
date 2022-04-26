//
//  Status.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit


/// 微博数据模型
@objcMembers
class Status: NSObject {
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博创建时间
    var created_at: String?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 点赞数
    var attitudes_count: Int = 0
    
    /// 缩略图
    /// 原创微博可以有图 也可以没有图 转发微博一定有图
    var thumbnail_pic: String?
    
    /// 配图数组
//    var pic_ids: [String: String]?
    
    /// 配图数组
    var pic_urls: [[String: String]]?
    
    /// 用户模型
    var user: User?
    
    /// 被转发的原微博信息字段
    var retweeted_status: Status?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                user = User(dict: dict)
            }
            return
        }
        
        if key == "retweeted_status" {
            if let dict = value as? [String: Any] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        let keys = ["id", "text", "created_at", "reposts_count", "comments_count", "attitudes_count", "pic_urls", "retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
