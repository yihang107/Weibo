//
//  StatusDAL.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/5.
//

import Foundation

// 最大缓存时间
private let maxCacheDateTime: TimeInterval = 7 * 24 * 60 * 60

// 目标: 专门负责处理本地的 SQLite和网络数据
class StatusDAL {
    /// 清理早于过期日期的缓存数据
    class func clearDataCache() {
        let date = Date(timeIntervalSinceNow: -maxCacheDateTime)
//        print(date)
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh_Hans_CN")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 获取日期结果
        let dateStr = df.string(from: date)
//        print(dateStr)
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        SQLiteManager.sharedManager.queue.inDatabase { db in
            if db.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                print("删除了\(db.changes)条缓存数据")
            }
        }
    }
    
    /// 加载微博数据
    class func loadStatus(since_id: Int, max_id: Int, finished: @escaping(_ array: [[String: Any]]?)->()) {
        // 检查本地是否存在缓存数据
        let array = checkChacheData(since_id: since_id, max_id: max_id)
        // 如果有 返回缓存数据
        if array?.count ?? 0 > 0 {
            print("查询到缓存数据")
            // 回调返回本地缓存数据
            finished(array)
        }
        
        // 如果没有 加载网络数据
        YYHNetworkTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { result, error in
            if error != nil {
                print("主页微博数据请求出错")
                print(error!)
                finished(nil)
                return
            }
            
//            print(result!)
            guard let newResult = result as? [String: Any] else{
                print("数据格式错误")
                finished(nil)
                return
            }
            
            guard let array = newResult["statuses"] as? [[String: AnyObject]] else {
                print("数据格式错误")
                finished(nil)
                return
            }
            
            // 将网络返回的数据, 保存到本地数据库, 以便后续使用
            StatusDAL.saveCacheData(array: array)
            finished(array)
        }
    }
    
    
    /// 检查本地数据库是否存在需要的数据
    /// 下拉和上拉Id
    private class func checkChacheData(since_id: Int, max_id: Int) -> [[String: Any]]? {
        guard let userId = UserAccountViewModel.sharedUserAccount.account?.uid else {
            print("用户没有登录")
            return nil
        }
        print("检查本地数据\(since_id)-\(max_id)")
        var sql = "SELECT statusId, status, userId FROM T_Status\n" +
                  "WHERE userId = \(userId)\n"
        
        if since_id > 0 {
            sql += "AND statusId > \(since_id)\n"
        } else if max_id > 0 {
            sql += "AND statusId < \(since_id)\n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        print("查询数据SQL->" + sql)
        
        // 执行SQL返回结果集合
        let array = SQLiteManager.sharedManager.execRecordSet(sql: sql)
//        print(array)
        var arrayM = [[String: Any]]()
        for dic in array {
            let jsonData = dic["status"] as! Data
            let result  = try! JSONSerialization.jsonObject(with: jsonData, options: [])
//            print(result)
            arrayM.append(result as! [String : Any])
        }
//        print(arrayM)
        
        return arrayM
    }
    
    
    /// 将网络返回的数据保存到本地数据库
    private class func saveCacheData(array: [[String: Any]]) {
        guard let userId = UserAccountViewModel.sharedUserAccount.account?.uid else {
            print("用户没有登录")
            return
        }
//        print("网络数据\(array)")
        // 如果不能确认数据插入的消耗时间 可以在实际开发中 写测试代码
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status, userId) VALUES (?, ?, ?);"
        SQLiteManager.sharedManager.queue.inTransaction { db, rollBack in
            for dict in array {
                let statusId = dict["id"] as! Int
                let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                do {
                    try db.executeUpdate(sql, values: [statusId, json, userId])
                } catch {
                    print(error)
                    break;
                }
            }
        }
        print("数据插入完成")
    }
}
