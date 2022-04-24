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
