//
//  FeedLowDataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/21.
//  Copyright © 2019 WHX. All rights reserved.
//

import UIKit
import Alamofire

class FeedLowDataCenter: NSObject, DataPageControlProtocol {
    
    typealias D = RecommendPageModel
    typealias B = RecommendPdModel
    
    var url = serverURL
    var path = bussinessURL
    
    var showCount:Int = 10
    var totalPage:Int = 0
    var totalResult:Int = 0
    var currentPage:Int = 0

    //data ary
    var headlineList = [HeadLineModel]()
    var cailianlist = [CailianModel]()
    var contentlist = [ContentModel]()
    
    var complete:completeBlock?
    
    func parseData(_ model: D?) {
        if model != nil {} else {return}
        
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
            if let r = try? JSONModel(BaseResponseModel<D>.self, withKeyValues: value as! [String : Any]) {
                
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
        weak var weakSelf = self
        requestData(url: url, parameters: ["currentPage":currentPage + 1, "showCount":self.showCount])
        { (value, result) in
            weakSelf?.completeAction(value:value, resultState:result)
        }
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
    
    func updatePage<B>(_ model: PageModel<B>?) -> Bool where B : Decodable, B : Encodable {
        
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
