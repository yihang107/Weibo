//
//  User.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit

/// 用户模型
@objcMembers
class User: NSObject {
    /// 用户UID
    var id: Int = 0
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（中国） 50*50
    var profile_image_url: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    

    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["id", "screen_name", "profile_image_url"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
