//
//  YYHNetworkTools.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/23.
//

import UIKit
import AFNetworking


enum NetworkRequestMethod: String {
case GET = "GET"
case POST = "POST"
}

class YYHNetworkTools: AFHTTPSessionManager {
    // MARK: 应用程序信息
//    private let appKey = "2045436852"
//    private let appSecret = ""
//    private let redirectUrl = "https://www.sina.com"
//    private let appKey = "3326691039"
//    private let appSecret = "75dd27596a081b28651d214e246c1b15"
//    private let redirectUrl = "http://api.weibo.com/oauth2/default.html"
    private let appKey = "1040309681"
    private let appSecret = "79694c2fc8f4a6c48ce606c164877d10"
    private let redirectUrl = "https://www.sina.com"
    private let redirectUrlEncoding = "https%3A%2F%2Fwww.sina.com"
    
    var fakeStashStatus: [StatusViewModel] = [StatusViewModel]()
    
    /// 类似于OC typeDefine 网络请求回调
    typealias YYHRequestCllBack = (_ result : Any?, _ error: Error?) -> ()
    
    /// 单例
    static let sharedTools: YYHNetworkTools = {
        let tools = YYHNetworkTools(baseURL: nil)
        // 设置反序列化数据格式 系统自动将OC中的NSSet转为Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        tools.responseSerializer.acceptableContentTypes?.insert("multipart/form-data")
//        tools.responseSerializer.acceptableContentTypes?.insert("gzip")
//        tools.responseSerializer.acceptableContentTypes?.insert("application/json;charset=UTF-8")
//        tools.responseSerializer.acceptableContentTypes?.insert("text/json")
        return tools
    }()
}

// MARK: - 发布微博
/// 发布的微博中需要带至少一个 应用绑定的安全域名  我们不具备域名 微博验证不同过 所有一直返回400
/// seet [https://open.weibo.com/wiki/2/statuses/share](https://open.weibo.com/wiki/2/statuses/share)
extension YYHNetworkTools {
    func sendStatus(status: String, image: UIImage?, finished: @escaping YYHRequestCllBack) {
        // 判断token是否有效
        // 设置参数 编码文本
//        if let encodeString = status.data(using: .utf8) {
//            params["status"] = encodeString
//        }
        var params = ["status": status]
        if image == nil {
            let urlString = "https://api.weibo.com/2/statuses/share.json"
    //        responseSerializer = AFHTTPResponseSerializer()
            tokenRequest(method: .POST, URLString: urlString, parameters: params, finished: finished)
        } else {
            let urlString = ""
            let imgData = image?.pngData()
            upload(URLString: urlString, data: imgData!, name: "pic", parameters: params, finished: finished)
        }
        
        let statusDic = ["text": status,
                         "pic_urls": [],
                         "created_at": "刚刚",
                         "user": ["screen_name": UserAccountViewModel.sharedUserAccount.account?.screen_name,
                                  "profile_image_url": UserAccountViewModel.sharedUserAccount.account?.avatar_large]] as [String : Any]
        let fakeStatus = StatusViewModel(status: Status(dict: statusDic))
        fakeStashStatus = [fakeStatus] + fakeStashStatus
    }
}


// MARK: - 微博数据相关方法
extension YYHNetworkTools {
    
    /// 加载主页微博数据
    /// see [https://api.weibo.com/2/statuses/home_timeline.json](https://api.weibo.com/2/statuses/home_timeline.json)
    func loadStatus(since_id: Int, max_id: Int,finished: @escaping YYHRequestCllBack) {
        var params = [String : Any]()
        //判断下拉
        if since_id > 0 {
            params["since_id"] = since_id
        } else if max_id > 0 {
            params["max_id"] = max_id - 1
        }
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        tokenRequest(method: NetworkRequestMethod.GET, URLString: urlString, parameters: params, finished: finished)
    }
}

// MARK: - 用户相关方法
extension YYHNetworkTools {
    ///加载用户信息
    ///see [https://open.weibo.com/wiki/2/users/show](https://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid: String, finished: @escaping YYHRequestCllBack) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        var params = [String : Any]()
        params["uid"] = uid
        tokenRequest(method: NetworkRequestMethod.GET, URLString: urlString, parameters: params, finished: finished)
    }
}

// MARK: - OAuth相关方法
extension YYHNetworkTools {
    /// OAuth授权
    /// - see: [授权](https://open.weibo.com/wiki/Oauth2/authorize)
    var oAuthURL: URL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrlEncoding)"
        return URL(string: urlString)!
    }
    
    /// 加载AccessToken
    func loadAccessToken(code: String, finished: @escaping YYHRequestCllBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": appKey,
                      "client_secret": appSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": redirectUrl]
        request(method: NetworkRequestMethod.POST, URLString: urlString, parameters: params, finished: finished)
        
        // 测试返回的数据内容 AFN默认返回格式是JSON, 会直接反序列化
//        responseSerializer = AFHTTPResponseSerializer()
    }
    
    /// 参数字典追加token
    /// inout 关键字 相当于OC中传递对象地址
    private func appendToken(params: inout [String : Any]?) -> Bool {
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            return false
        }
        
        var newParameters = params
        if newParameters == nil {
            newParameters = [String : Any]()
        }
        newParameters!["access_token"] = token
        params = newParameters
        return true
    }
    
    /// 请求中添加token参数
    func tokenRequest(method: NetworkRequestMethod, URLString: String, parameters: [String: Any]? , finished:  @escaping YYHRequestCllBack) {
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            finished(nil, NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token过期"]))
            return
        }
        
        var newParameters = parameters
        if newParameters == nil {
            newParameters = [String : Any]()
        }
        newParameters!["access_token"] = token
        
        request(method: method, URLString: URLString, parameters: newParameters, finished: finished)
    }
}

// MARK: 封装AFN网络方法
extension YYHNetworkTools {
    /// 一般网络请求
    private func request(method: NetworkRequestMethod, URLString: String, parameters: [String: Any]? , finished:  @escaping YYHRequestCllBack) {
        dataTask(withHTTPMethod: method.rawValue, urlString: URLString, parameters: parameters, headers: nil, uploadProgress: nil, downloadProgress: { _ in
            
        }, success: { _, result in
            finished(result, nil)
        }, failure: { _, error in
//            print(error)
            finished(nil, error)
        })?.resume()

    }
    
    ///  上传文件
    private func upload(URLString: String, data: Data, name: String, parameters: [String: Any]?, finished: @escaping YYHRequestCllBack) {
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            finished(nil, NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token过期"]))
            return
        }
        
        var newParameters = parameters
        if newParameters == nil {
            newParameters = [String : Any]()
        }
        newParameters!["access_token"] = token
        
        self.post(URLString, parameters: parameters, headers: nil) { formData in
            /**
             data 上传文件的二进制
             name 服务器定义的字段名
             fileName 保存在服务器的文件名  通常可以乱写 后台会做处理
                根据上传的文件, 生成缩略图，中等图, 高清图
                保存在不同路径, 并自动生成文件名
                fileName是HTTP协议定义的属性
             mimeType/ ContentType: 客户端告诉服务器, 二进制数据的准确类型
                大类型/小类型
                    iamge/jpg  image/git img/png
                    text/plain text/html
                    applictaion/json
                不想告诉图片服务器准确的类型
                    application/octet-stream
             
             */
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
        } progress: { _ in
            
        } success: { _, result in
            finished(result, nil)
        } failure: { _, error in
            print(error)
            finished(nil, error)
        }

    }
}
