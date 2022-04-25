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
    
    /// 类似于OC typeDefine 网络请求回调
    typealias YYHRequestCllBack = (_ result : Any?, _ error: Error?) -> ()
    
    /// 单例
    static let sharedTools: YYHNetworkTools = {
        let tools = YYHNetworkTools(baseURL: nil)
        // 设置反序列化数据格式 系统自动将OC中的NSSet转为Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
    /// 返回token字典
    private var tokenDict: [String: Any]? {
        if let token = UserAccountViewModel.sharedUserAccount.accessToken {
            return ["access_token": token]
        }
        
        return nil
    }
}

// MARK: 用户相关方法
extension YYHNetworkTools {
    ///加载用户信息
    ///see [https://open.weibo.com/wiki/2/users/show](https://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid: String, finished: @escaping YYHRequestCllBack) {
        // 获取token字典
        guard var params = tokenDict else {
            // 如果字典为nil, 通知调用方， token无效
            finished(nil, NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token为空"]))
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        params["uid"] = uid
        request(method: NetworkRequestMethod.GET, URLString: urlString, parameters: params, finished: finished)
    }
}

// MARK: OAuth相关方法
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
}

// MARK: 封装AFN网络方法
extension YYHNetworkTools {
    /// 网络请求
    private func request(method: NetworkRequestMethod, URLString: String, parameters: [String: Any]? , finished:  @escaping YYHRequestCllBack) {
        dataTask(withHTTPMethod: method.rawValue, urlString: URLString, parameters: parameters, headers: nil, uploadProgress: nil, downloadProgress: { _ in
            
        }, success: { _, result in
            finished(result, nil)
        }, failure: { _, error in
            print(error)
            finished(nil, error)
        })?.resume()

    }
}
