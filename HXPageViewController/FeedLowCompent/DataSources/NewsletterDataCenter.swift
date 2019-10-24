//
//  NewsletterDataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/24.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import Alamofire

class NewsletterDataCenter: NSObject, DataPageControlProtocol {
    
    typealias D = NewsletterPageModel
    typealias B = NewsletterModel
    
    var url = serverURL
    var path = bussinessURL
    
    var showCount:Int = 10
    var totalPage:Int = 0
    var totalResult:Int = 0
    var currentPage:Int = 0
    
    //data ary
    var cailianlist = [String:[B]]()
    var headList = [String]()
    
    var complete:completeBlock?
    
    func parseData(_ model:D?) {

        guard let modelList = model?.cailianlist else { return }

        let tmpCailianlist = cailianlist

        for model in modelList {
            guard let month = model.date else { continue }
            guard let monthList = model.list else { continue }

            var finMonthList:[B] = [B]()

            if let nowList = tmpCailianlist[month] {
                finMonthList = nowList + monthList
            } else {
                headList.append(month)
                finMonthList += monthList
            }

            finMonthList = finMonthList.handleFilter({ $0.ID })

            cailianlist[month] = finMonthList
        }

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
extension NewsletterDataCenter {
    
    //结果 Bool 类型可能不够, 需要增加 noMoreData 类型标志
    open func nextPage() {
        
        let url = self.url + path
        
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
        
        cailianlist.removeAll()
        headList.removeAll()
    }
    
    open func lastestPage() {
        clearData()
        nextPage()
    }
    
    func updatePage<T>(_ model: PageModel<T>?) -> Bool where T : Decodable, T : Encodable {
        
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
