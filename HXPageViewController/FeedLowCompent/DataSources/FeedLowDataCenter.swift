//
//  FeedLowDataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/21.
//  Copyright © 2019 WHX. All rights reserved.
//

import UIKit
import Alamofire
//www.wogoo.com
//39.107.127.12
//todo xiaofengmin server URL
let testUrl = "http://39.107.127.12/server/appHomePage/app/list?currentPage=0&showCount=2"
let serverURL = "http://www.wogoo.com/server"
let bussinessURL = "/appHomePage/app/list"

typealias completeBlock = (State, String?) -> Void

class FeedLowDataCenter: NSObject, DataPageControlProtocol {
    
    var showCount:Int = 10
    var totalPage:Int = 0
    var totalResult:Int = 0
    var currentPage:Int = 0

    //data ary
    var headlineList = [HeadLineModel]()
    var cailianlist = [CailianModel]()
    var contentlist = [ContentModel]()
    
    var complete:completeBlock?
    
    func parseData(_ model:HomePageModel?) {
        var tmpHeadLineList = headlineList
        if let newHeadList = model?.headlineList {
            tmpHeadLineList += newHeadList
        }
        
        var tmpCailianlist = cailianlist
        if let newCailList = model?.cailianlist {
            tmpCailianlist += newCailList
        }
        
        var tmpContentList = contentlist
        if let newContentList = model?.contenList {
            tmpContentList += newContentList
        }
        
        headlineList = tmpHeadLineList.handleFilter({ $0.articleID })
        cailianlist = tmpCailianlist.handleFilter({ $0.ID })
        contentlist = tmpContentList.handleFilter({ $0.articleID })
        
    }
    
    func completeAction(value:Any?, resultState:Bool) {
        if let value = value {
            var msg:String?
            if let r = try? JSONModel(BaseResponseModel<HomePageModel>.self, withKeyValues: value as! [String : Any]) {
                
                msg = r.resultMsg

                if r.resultState == true {
                    self.parseData(r.data)
                    let moreData = self.updatePage(r.data?.page)
                    
                    if moreData {
                        self.complete?(State.success, msg)
                    } else {
                        self.complete?(State.noMoreData, msg)
                    }
                } else {
                    self.complete?(State.fail, r.resultMsg)
                }
            } else {
                self.complete?(State.fail, nil)
            }
        } else {
            self.complete?(State.fail, nil)
        }
    }
    
}

//MARK: - DataPageControlProtocol
extension FeedLowDataCenter {
    
    //结果 Bool 类型可能不够, 需要增加 noMoreData 类型标志
    open func nextPage() {
        
        let url = serverURL + bussinessURL
        
        requestData(url: url,
                    parameters:
            ["currentPage":currentPage + 1,
             "showCount":self.showCount],
                    completion:{(value, result) in
                        
                        self.completeAction(value:value, resultState:result)
                        
        })
    }
    
    open func clearData() {
        totalPage = 0
        totalResult = 0
        currentPage = 0
        headlineList.removeAll()
        cailianlist.removeAll()
        contentlist.removeAll()
    }
    
    open func lastestPage() {
        clearData()
        nextPage()
    }
    
    func updatePage(_ model:PageModel?) -> Bool {
        if model != nil {
            self.currentPage = model?.currentPage ?? currentPage + 1
            self.totalPage = model?.totalPage ?? totalPage
            self.totalResult = model?.totalResult ?? totalResult
        }
        if currentPage <= totalPage {
            return true
        } else {
            return false
        }
    }
}

extension FeedLowDataCenter {
    
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
