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
    // 单例
    static let sharedTools: YYHNetworkTools = {
        let tools = YYHNetworkTools(baseURL: nil)
        // 设置反序列化数据格式 系统自动将OC中的NSSet转为Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
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
