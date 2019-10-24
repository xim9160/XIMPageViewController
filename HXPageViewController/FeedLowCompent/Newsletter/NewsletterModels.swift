//
//  NewsletterModels.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/23.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

public struct NewsletterPageModel:Codable {
    var refreshTime:String?
    var cailianlist:[CailianListModel]?
    var page:PageModel<NewsletterPdModel>?
    
    private enum CodingKeys:String, CodingKey {
        case refreshTime = "refreshTime"
        case cailianlist = "cailianlist"
        case page = "page"
    }
}

public struct CailianListModel:Codable {
    var date:String?
    var webDate:String?
    var list:[NewsletterModel]?

    private enum CodingKeys:String, CodingKey {
        case date = "DATE"
        case webDate = "WEBDATE"
        case list = "LIST"
    }
}

public struct NewsletterModel:Codable {
    var brief:String?
    var recommend:Int?
    var subjectTitles:String?
    var originalTime:String?
    var time:String?
    var title:String?
    var ID:Int?
    var stocks:String?
    var author:String?
    var type:Int?
    
    private enum CodingKeys:String, CodingKey {
        case brief = "BRIEF"
        case recommend = "RECOMMEND"
        case subjectTitles = "SUBJECT_TITLES"
        case originalTime = "CTIME_ORIGINAL"
        case time = "CTIME"
        case title = "TITLE"
        case ID = "ID"
        case stocks = "STOCKS"
        case author = "AUTHOR"
        case type = "TYPE"
    }
    
}

public struct NewsletterPdModel:Codable {
    var showCount:String? //todo xiaofengmin string
    var refreshTime:Double?
    var currentPage:String?
    
    private enum CodingKeys:String, CodingKey {
        case showCount = "showCount"
        case refreshTime = "refreshTime"
        case currentPage = "currentPage"
    }
    
}
