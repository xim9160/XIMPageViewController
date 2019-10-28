//
//  ChannelModelCreater.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/23.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit

/// 配套 ChannelEditController 使用 方便 [String] -> [Models]
public struct ChannelModelCreater {
    
    
    /// 简易数模装换
    /// - Parameter name: model.name
    /// - Parameter cID: 预留字段, 后续可能 用 vc.class 代替
    /// - Parameter isTop: model.当前的显示状态
    static func channelUnitModel(_ name:String, cID:String = "0", isTop:Bool) -> ChannelUnitModel {
        let model = ChannelUnitModel()
        model.name = name
        model.cid = cID
        model.isTop = isTop
        return model
    }
    
    /// 简易数模装换
    /// - Parameter name ...: 字符串 数组
    /// - Parameter cID: 预留字段, 后续可能 用 vc.class 代替
    /// - Parameter isTop: model.当前的显示状态
    static func channelUntilModels(isTop:Bool, cID:String = "0", _ names:String ...) -> [ChannelUnitModel] {
        var models = [ChannelUnitModel]()
        for name in names {
            let model = channelUnitModel(name, isTop: isTop)
            models.append(model)
        }
        return models
    }
    
    /// 简易数模装换
    /// - Parameter names: 显示字符串数组
    /// - Parameter cID: 预留字段, 后续可能 用 vc.class 代替
    /// - Parameter isTop: model.当前的显示状态
    static func channelUntilModels(isTop:Bool, cID:String = "0", _ names:[String]) -> [ChannelUnitModel] {
        var models = [ChannelUnitModel]()
        for name in names {
            let model = channelUnitModel(name, isTop: isTop)
            models.append(model)
        }
        return models
    }
    
}
