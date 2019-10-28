//
//  ServiceApi.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/28.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit
import Moya

let testURL = "http://39.107.127.12/server"
let releaseURL = "http://www.wogoo.com/server"


/// 调用配置
public enum ValueStormApi {
    case login(name:String, pwd:String)
    case service(type:serviceType, params:[String:Any]?)
    
    /// 基础和URL配置
    public enum config {
        case release
        case test
        
        var urlString:String {
            switch self {
            case .release:
                return releaseURL
            case .test:
                return testURL
            }
        }
    }
    
    
    /// 具体业务path
    public enum serviceType {
        case homeList
        case cailianList
        
        var path:String {
            switch self {
            case .homeList:
                return "/appHomePage/app/list"
            case .cailianList:
                return "/appCaiLianPress/list"
            }
        }
    }
    
}

extension ValueStormApi:TargetType {
    public var baseURL: URL {
        return URL(string: ValueStormApi.config.release.urlString)!
    }
    
    public var path: String {
        switch self {
        case .login(_, _):
            return "/appUser/login"
        case .service(let type, _):
            return type.path
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    
    /// 默认数据暂不实现
    public var sampleData: Data {
        switch self {
        case .login(_, _):
            return "".data(using: String.Encoding.utf8)!//暂时默认不带数据
        default:
            return "".data(using: String.Encoding.utf8)!//暂时默认不带数据
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let name, let pwd):
            return .requestParameters(parameters: ["username" : name, "password":pwd], encoding: URLEncoding.default)
        case .service(_, let params):
            return .requestParameters(parameters: params ?? [:], encoding: URLEncoding.default)
        }
    }
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - 超时时间设置
public let requestTimeoutClosure = { (endpoint: Endpoint, done: MoyaProvider<ValueStormApi>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 20
        done(.success(request))
    } catch {
        return
    }
}
