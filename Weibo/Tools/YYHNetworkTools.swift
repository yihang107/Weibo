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
    private let appKey = ""
    private let appSecret = ""
    private let redirectUrl = ""
    
    
    // 单例
    static let sharedTools: YYHNetworkTools = {
        let tools = YYHNetworkTools(baseURL: nil)
        // 设置反序列化数据格式 系统自动将OC中的NSSet转为Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
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
}

// MARK: 封装AFN网络方法
extension YYHNetworkTools {
    /// 网络请求
    func request(method: NetworkRequestMethod, URLString: String, parameters: [String: AnyObject]? , finished:  @escaping(_ result: Any?, _ error: Error?)->()) {
        dataTask(withHTTPMethod: method.rawValue, urlString: URLString, parameters: parameters, headers: nil, uploadProgress: nil, downloadProgress: { _ in
            
        }, success: { _, result in
            finished(result, nil)
        }, failure: { _, error in
            print(error)
            finished(nil, error)
        })?.resume()

    }
}
