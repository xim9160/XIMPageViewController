//
//  FeedLowHomeChannelConfig.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/23.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit

public struct FeedLowHomeChannelConfig {
    
    static let saveKey = "FeedLowHomePageConfig_\("USER_ID")_TITLES"
    static let defaultTitles = ["推荐", "沪深", "港股", "美股", "7x24小时", "其他"]
    static let defaultHideTitles = ["新闻", "全部", "资讯", "调试", "其他", "7x64"]
    
    var controllers:[String:UIViewController] = [String:UIViewController]()
    
    var titles = { () -> [String] in
        
        var showList = [String]()
        
        if let list = UserDefaults.standard.object(forKey: FeedLowHomeChannelConfig.saveKey) as? [String] {
            showList = list
        } else {
            showList = FeedLowHomeChannelConfig.defaultTitles
        }
        
        return showList
    }()
    
    var hideTitles:[String] {
        get {
            let totalTitles = FeedLowHomeChannelConfig.defaultTitles + FeedLowHomeChannelConfig.defaultHideTitles
            let showList = titles
            
            let totalSet = Set(totalTitles)
            let showSet = Set(showList)
            
            let hideList = totalSet.symmetricDifference(showSet).sorted()
            return hideList
        }
    }
    
    func map(_ title: String) -> AnyClass {
        switch title {
        case "推荐":
            return RecommendPageViewController.self
        default:
            return DetailViewController.self
        }
    }
    
    mutating func reloadTitles() -> Void {
        if let list = UserDefaults.standard.object(forKey: FeedLowHomeChannelConfig.saveKey) as? [String] {
            self.titles = list
        } else {
            self.titles = FeedLowHomeChannelConfig.defaultTitles
        }
    }
    
    func saveConfig(list:[String]) -> Void {
        UserDefaults.standard.set(list, forKey: FeedLowHomeChannelConfig.saveKey)
    }
    
    func saveConfig(modeles:[ChannelUnitModel]) -> Void {
        var saveList = [String]()
        for model in modeles {
            saveList.append(model.name)
        }
        saveConfig(list:saveList)
    }
    
}
