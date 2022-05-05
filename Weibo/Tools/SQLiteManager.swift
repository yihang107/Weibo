//
//  SQLiteManager.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/5.
//

import Foundation


/// 关于数据库名称
private let dbname = "readme.db"

class SQLiteManager {
    // 单例
    static let sharedManager = SQLiteManager()
    
    // 全局数据库操作队列
    let queue: FMDatabaseQueue
    private init () {
        // 打开数据库队列
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbname)
        print("数据库路径" + path)
//        FMDatabaseQueue()
        // 如果数据库不存在, 会建立数据库, 然后再创建队列打开数据库
        // 如果数据库存在, 会直接创建队列并且打开数据库
        queue  = FMDatabaseQueue(path: path)!
        createTable()
    }
    
    private func createTable() {
        queue.inDatabase { db in
            let path = Bundle.main.path(forResource: "db.sql", ofType: nil)
            print(path)
            let sql =  try! String(contentsOfFile: path!)
            // 执行对调语句
            if db.executeStatements(sql) {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
    }
    
    func execRecordSet(sql: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        SQLiteManager.sharedManager.queue.inDatabase { db in
            do {
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    let colCount = rs.columnCount
                    var dict = [String: Any]()
                    for col in 0..<colCount {
                        let name = rs.columnName(for: col)
                        let obj = rs.object(forColumnIndex: col)
                        dict[name!] = obj
                    }
                    result.append(dict)
                }
            } catch {
                
            }
        }
        return result
    }
}
