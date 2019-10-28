//
//  RecommendDataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/21.
//  Copyright © 2019 WHX. All rights reserved.
//

import UIKit
import Alamofire
import Moya

class RecommendDataCenter: NSObject, DataPageControlProtocol {
    
    typealias D = RecommendPageModel
    typealias B = RecommendPdModel
    
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
    
}

//MARK: - DataPageControlProtocol
extension RecommendDataCenter {
    
    //结果 Bool 类型可能不够, 需要增加 noMoreData 类型标志
    open func nextPage() {
        let provider = MoyaProvider<ValueStormApi>(requestClosure:requestTimeoutClosure)
        provider.request(.service(type: .homeList, params: ["currentPage":currentPage + 1, "showCount":self.showCount])) { [unowned self] (result) in
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
