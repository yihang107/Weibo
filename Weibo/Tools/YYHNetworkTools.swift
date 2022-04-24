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
    // MARK: 应用程序消息
    private let appKey = "2045436852"
    private let appSecret = ""
    private let redirectUrl = "https://www.sina.com"
    
    /// 类似于OC typeDefine 网络请求回调
    typealias YYHRequestCllBack = (_ result : Any?, _ error: Error?) -> ()
    
    // 单例
    static let sharedTools: YYHNetworkTools = {
        let tools = YYHNetworkTools(baseURL: nil)
        // 设置反序列化数据格式 系统自动将OC中的NSSet转为Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

// MARK: OAuth相关方法
extension YYHNetworkTools {
    /// OAuth授权
    /// - see: [授权](https://open.weibo.com/wiki/Oauth2/authorize)
    var oAuthURL: URL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrl)"
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
    }
}

// MARK: 封装AFN网络方法
extension YYHNetworkTools {
    /// 网络请求
    private func request(method: NetworkRequestMethod, URLString: String, parameters: [String: String]? , finished:  @escaping YYHRequestCllBack) {
        dataTask(withHTTPMethod: method.rawValue, urlString: URLString, parameters: parameters, headers: nil, uploadProgress: nil, downloadProgress: { _ in
            
        }, success: { _, result in
            finished(result, nil)
        }, failure: { _, error in
            print(error)
            finished(nil, error)
        })?.resume()

    }
}
