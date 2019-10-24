//
//  RecommendModels.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/23.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

public struct RecommendPageModel:Codable {
    var refreshTime:String?
    var headlineList:[HeadLineModel]?
    var cailianlist:[CailianModel]?
    var page:PageModel<RecommendPdModel>?
    var contenList:[ContentModel]?
    
    private enum CodingKeys:String, CodingKey {
        case refreshTime = "refreshTime"
        case headlineList = "headlineList"
        case cailianlist = "cailianlist"
        case page = "page"
        case contenList = "list"
    }
}

public struct RecommendPdModel:Codable {
    var showCount:String? //todo xiaofengmin string
    var checkParamMsg:String?
    var checkParamState:Bool?
    var refreshTime:String?
    var type:String?
    var userID:String?
    var currentPage:String?
    
    private enum CodingKeys:String, CodingKey {
        case showCount = "showCount"
        case checkParamMsg = "checkParamMsg"
        case checkParamState = "checkParamState"
        case refreshTime = "refreshTime"
        case type = "N_TYPE"
        case userID = "USER_ID"
        case currentPage = "currentPage"
    }
    
}

public struct HeadLineModel:Codable {
    var watchNum:Double?
    var authorID:String?
    var articleURL:String?
    var introduce:String?
    var nickName:String?
    var likeNum:Double?
    var commentNum:Double?
    var disLikeNum:Double?
    var titleImgType:String?
    var relEasyTime:String?
    var imgList:[ImgModel]?
    var titleImg:String?
    var img:String?
    var articleID:String?
    var rewardMoney:Double?
    var title:String?
    
    private enum CodingKeys:String, CodingKey {
        case watchNum = "N_WATCH_NUM"
        case authorID = "C_UID"
        case articleURL = "article_url"
        case introduce = "C_INTRODUCE"
        case nickName = "C_NICKNAME"
        case likeNum = "N_LIKE_NUM"
        case commentNum = "N_COMMENT_NUM"
        case disLikeNum = "N_DISLIKE_NUM"
        case titleImgType = "C_TITLEIMG_TYPE"
        case relEasyTime = "T_RELEASE_TM"
        case imgList = "IMGLIST"
        case titleImg = "C_TITLE_IMG"
        case img = "C_IMG"
        case articleID = "ARTICLE_ID"
        case rewardMoney = "N_REWARD_MONEY"
        case title = "C_TITLE"
    }
    
}

public struct CailianModel:Codable {
    var brief:String?
    var recommend:Double?
    var title:String?
    var ID:Double?
    var type:Double?

    private enum CodingKeys:String, CodingKey {
        case brief = "BRIEF"
        case recommend = "RECOMMEND"
        case title = "TITLE"
        case ID = "ID"
        case type = "TYPE"
    }
    
}

public struct ContentModel:Codable {
    var type:String?//来源 是否是市值纷纭
    var watchNum:Double?
    var homePageID:Double?
    var authorID:String?
    var pType:Int?//文章还是文有圈
    var isTop:Double?
    var descriptionTime:String?
    var url:String?
    var time:String?
    var articleID:String?
    var label:String?
    var authorName:String?
    var commentNum:Double?
    var images:[String]?
    var authorIcon:String?
    var title:String?
    var channel:String?
    
    private enum CodingKeys:String, CodingKey {
        case type = "C_TYPE"
        case watchNum = "N_WATCH_NUM"
        case homePageID = "HOMEPAGE_ID"
        case authorID = "C_UID"
        case pType = "N_PTYPE"
        case isTop = "N_IS_TOP"
        case descriptionTime = "T_CRT_TM"
        case url = "C_URL"
        case time = "C_CRT_TM"
        case articleID = "C_PID"
        case label = "C_LABEL"
        case authorName = "C_UNAME"
        case commentNum = "N_COMMENT_NUM"
        case images = "C_IMAGES"
        case authorIcon = "C_IMG"
        case title = "C_TITLE"
        case channel = "HOMEPAGE_CHANNEL"
    }
    
}

public struct ImgModel:Codable {
    var url:String?
    var name:String?
    
    private enum CodingKeys:String, CodingKey {
        case url = "PATH"
        case name = "C_NAME"
    }
    
}
