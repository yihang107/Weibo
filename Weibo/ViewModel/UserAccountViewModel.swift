//
//  UserAccountViewModel.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/24.
//

import Foundation

/**
 模型通常继承NSObject 可以使用KVC
 如果没有父类 所有内容都需要从头创建 量级更轻
 视图模型作用: 封装业务逻辑 通常没有复杂的属性
 */
/// 用户账号视图模型
class UserAccountViewModel {
    /// 单例
    static let sharedUserAccount = UserAccountViewModel()
    
    /// 用户模型
    var account: UserAccount?
    
    /// 用户登记标志
    var userLogin: Bool {
        return account?.access_token != nil && !isExpired
    }
    
    /// 归档保存路径  计算型属性
    private var accountPath: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return path.appending("/account.plist")
    }
    
    private var isExpired: Bool {
        // 判断token的过期日期
        if account?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    
    /// 要求外部只能通过单例常量访问
    private init() {
        // 从沙盒解档
        do {
            print(accountPath)
            let data = try Data(contentsOf: URL(fileURLWithPath: accountPath))
            account = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserAccount
//            account = try? NSKeyedUnarchiver.unarchivedObject(ofClass:UserAccount.self, from: data)
            
            // 判断是否过期
            if isExpired {
                // 清空解档数据
                account = nil
            }
        } catch {
            print("读取目录下用户数据失败\(error)")
        }
    }
}


extension UserAccountViewModel {
    
    func loadAccessToken(code: String, finished: @escaping(_ isSuccessed: Bool)->()) {
        YYHNetworkTools.sharedTools.loadAccessToken(code: code) { result, error in
//            if error != nil {
//                print("没有获取到accessToken")
//                finished(false)
//                return
//            }
        
//            let account = UserAccount(dict: result as! [String : Any])
            self.account = UserAccount.init(dict: ["access_token": "fadsf", "uid": "1404376560", "expires_in": 157679999])
            self.loadUserInfo(account: self.account!, finished: finished)
        }
    }
    
    private func loadUserInfo(account: UserAccount, finished: @escaping(_ isSuccessed: Bool)->()) {
        YYHNetworkTools.sharedTools.loadUserInfo(uid: account.uid!, accessToken: account.access_token!) { result, error in
//            if error != nil {
//                print("加载用户出错")
//                finished(false)
//                return
//            }
//
//            guard let dict = result as? [String : Any] else {
//                print("用户信息格式错误")
//                finished(false)
//                return
//            }
            
            let dict1 = [
                "id": 1404376560,
                "screen_name": "zaku",
                "name": "zaku",
                "province": "11",
                "city": "5",
                "location": "北京 朝阳区",
                "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
                "url": "http://blog.sina.com.cn/zaku",
                "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
                "domain": "zaku",
                "gender": "m",
                "followers_count": 1204,
                "friends_count": 447,
                "statuses_count": 2908,
                "favourites_count": 0,
                "created_at": "Fri Aug 28 00:00:00 +0800 2009",
                "following": false,
                "allow_all_act_msg": false,
                "geo_enabled": true,
                "verified": false,
                "status": [
                    "created_at": "Tue May 24 18:04:53 +0800 2011",
                    "id": 11142488790,
                    "text": "我的相机到了。",
                    "source": "<a href='http://weibo.com' rel='nofollow'>新浪微博</a>",
                    "favorited": false,
                    "truncated": false,
                    "in_reply_to_status_id": "",
                    "in_reply_to_user_id": "",
                    "in_reply_to_screen_name": "",
                    "geo": nil,
                    "mid": "5610221544300749636",
                    "annotations": [],
                    "reposts_count": 5,
                    "comments_count": 8
                ],
                "allow_all_comment": true,
                "avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
                "verified_reason": "",
                "follow_me": false,
                "online_status": 0,
                "bi_followers_count": 215
            ] as [String : Any]
            
            // 将用户信息保存
            account.screen_name = dict1["screen_name"] as? String
            account.avatar_large = dict1["avatar_large"] as? String
            print(account)
            self.saveUserAccount()
            
            finished(true)
        }
    }
    
    // MARK: 保存当前对象
    func saveUserAccount() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.account!, requiringSecureCoding: true)
            do {
                try data.write(to: URL(fileURLWithPath: accountPath))
            } catch {
                print("用户data存入失败\(error)")
            }
        } catch {
            print("用户模型转data失败\(error)")
        }
    }
}
