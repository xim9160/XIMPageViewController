//
//  DataCenterModel.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

public struct BaseResponseModel<T:Codable>:Codable {
    var data:T?
    var resultState:Bool?
    var resultCode:String?
    var resultMsg:String?
    
    private enum CodingKeys:String, CodingKey {
        case data = "data"
        case resultState = "resultState"
        case resultCode = "resultCode"
        case resultMsg = "resultMsg"
    }
}

public struct PageModel<T:Codable>:Codable{
    var showCount:Int?
    var totalPage:Int?
    var totalResult:Int?
    var currentPage:Int?
    var currentResult:Int?
    var entityOrField:Bool?
    var pd:T?
    
    private enum CodingKeys:String, CodingKey {
        case showCount = "showCount"
        case totalPage = "totalPage"
        case totalResult = "totalResult"
        case currentPage = "currentPage"
        case currentResult = "currentResult"
        case entityOrField = "entityOrField"
        case pd = "pd"
    }
    
}

public func JSONModel<T>(_ type: T.Type, withKeyValues data:[String:Any]) throws -> T where T: Decodable {
    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
    let model = try JSONDecoder().decode(type, from: jsonData)
    return model
}

extension KeyedDecodingContainer {
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}
