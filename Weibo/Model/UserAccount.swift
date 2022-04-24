//
//  UserAccount.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/24.
//

import UIKit

/// 用户账户模型
@objcMembers
class UserAccount: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    /// 同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态
    var access_token: String?
    /// access_token的生命周期， 单位是秒数
    /// 一旦从服务器获得过期的时间，立刻计算准确日期
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: Date?
    
    /// 授权用户的UID
    @objc var uid: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String :Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override class func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override class func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["access_token", "expires_in", "uid", "expiresDate", "screen_name", "avatar_large"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    // MARK: 保存当前对象
    func saveUserAccount() {
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        path = path.appending("/account.plist")
        // 实际开发中一定要确认文件保存下来了
        print("用户归档保存路径\(path)")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            do {
                try data.write(to: URL(fileURLWithPath: path))
            } catch {
                print("用户data存入失败\(error)")
            }
        } catch {
            print("用户模型转data失败\(error)")
        }
    }
    
    // MARK: 归档和解档  键值
    /// 把当前对象保存到磁盘前，将对象编码成二进制数据 和网络的序列化
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expiresDate, forKey: "expiresDate")
        coder.encode(uid, forKey: "uid")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")
    }
    
    /// 解档 从磁盘加载二进制文件 转换成对象时使用。和网络的反序列化很想
    /// 返回当前对象
    ///  required 没有继承性 所有对象只能解档出当前对象
    required init?(coder: NSCoder) {
        access_token = coder.decodeObject(forKey: "access_token") as? String
        expiresDate = coder.decodeObject(forKey: "expiresDate") as? Date
        uid = coder.decodeObject(forKey: "uid") as? String
        screen_name = coder.decodeObject(forKey: "screen_name") as? String
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String
    }
}

// extension中只能写便利构造函数 不能写指定构造函数 不能定义存储性属性 定义存储性属性会破坏类本身的结构
