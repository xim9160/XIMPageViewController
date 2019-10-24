//
//  DataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import Alamofire

enum State {
    case success
    case fail
    case noMoreData
}

public typealias DataPageControlProtocol = DataPageModelProtocol & DataPageActionsProtocol & DataPageRequestProtocol

typealias completeBlock = (State, String?) -> Void

public protocol DataPageModelProtocol {
    
    var url:String {set get}
    var path:String {set get}
    
    var showCount:Int { get }
    var totalPage:Int { get set }
    var totalResult:Int { get set }
    var currentPage:Int { get set }
}

public protocol DataPageActionsProtocol {
    
    func nextPage()
    
    func clearData()
    
    func lastestPage()
    
    func updatePage<T:Codable>(_ model:PageModel<T>?) -> Bool
    
}

public protocol DataPagePageProtocol {
    
    var showCount:Int { get }
    var totalPage:Int { get set }
    var totalResult:Int { get set }
    var currentPage:Int { get set }
    
    func nextPage()
    
    func clearData()
    
    func lastestPage()
    
    func updatePage<T:Codable>(_ model:PageModel<T>?) -> Bool
}

public protocol DataPageRequestProtocol {
    func requestData(url:URLConvertible, method:HTTPMethod, timeoutInterval:TimeInterval, headers:HTTPHeaders?, parameters:Parameters?, completion: @escaping (_ value: Any?,_ isSuccess: Bool)->())
}

extension DataPageRequestProtocol {
    func requestData(url: URLConvertible,
                 method: HTTPMethod = .get ,
                 timeoutInterval: TimeInterval = 5,
                 headers: HTTPHeaders? = nil,
                 parameters: Parameters? = nil,
                 completion: @escaping (_ value: Any?,_ isSuccess: Bool)->()) {
        //
        guard var myURLRequest = try? URLRequest(url: url, method: method, headers: headers) else{
            print("错误的URLRequest")
            return
        }
        guard let encodedURLRequest = try? URLEncoding.default.encode(myURLRequest, with: parameters) else{
            print("错误的URLEncoding")
            return
        }
        //
        myURLRequest.timeoutInterval = timeoutInterval
        //auth
        SessionManager.default.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        //
        Alamofire.request(encodedURLRequest).responseJSON { (response) in
            //
            if response.result.isSuccess {
                completion(response.result.value,true)
            }else {
                print("错误的：")
                print(url)
                print(response.error!)
                completion(nil,false)
            }
        }
    }
}
