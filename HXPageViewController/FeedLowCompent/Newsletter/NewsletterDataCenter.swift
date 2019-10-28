//
//  NewsletterDataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/24.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import Alamofire
import Moya

class NewsletterDataCenter: NSObject, DataPageControlProtocol {
    
    typealias D = NewsletterPageModel
    typealias B = NewsletterModel
    
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
    
}


//MARK: - DataPageControlProtocol
extension NewsletterDataCenter {
    
    //结果 Bool 类型可能不够, 需要增加 noMoreData 类型标志
    open func nextPage() {
        
        let provider = MoyaProvider<ValueStormApi>(requestClosure:requestTimeoutClosure)
        provider.request(.service(type: .cailianList, params: ["currentPage":currentPage + 1, "showCount":self.showCount])) { [unowned self] (result) in
            var state = State.fail
            switch result {
            case let .success(response):
                do {
                    let model = try response.map(BaseResponseModel<D>.self)
                    let pgModel = model.data
                    self.parseData(pgModel)
                    let moreData = self.updatePage(pgModel?.page)
                    
                    state = moreData ? State.success : State.noMoreData
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
            
            self.complete?(state, nil)
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
