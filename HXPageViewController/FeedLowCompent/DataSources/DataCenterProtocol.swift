//
//  DataCenter.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import Moya

enum State {
    case success
    case fail
    case noMoreData
}

public typealias DataPageControlProtocol = DataPageModelProtocol & DataPageActionsProtocol

typealias completeBlock = (State, String?) -> Void

public protocol DataPageModelProtocol {
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
