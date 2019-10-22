//
//  ArrayExtension.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

// MARK: - 模型数组按照属性筛选, 去重
extension Array {

  //该函数的参数filterCall是一个带返回值的闭包，传入模型T，返回一个E类型
    func handleFilter<E: Equatable, T>(_ filterCall: (T) -> E) -> [T] {
      var temp = [T]()
      for model in self {
          //调用filterCall，获得需要用来判断的属性E
        let model = model as! T
        let identifer = filterCall(model)
        //此处利用map函数 来将model类型数组转换成E类型的数组，以此来判断
        //          identifer 是否已经存在，如不存在则将model添加进temp
        if !temp.map( { filterCall($0) } ).contains(identifer) {
            temp.append(model)
        }
      }
      return temp
   }
}
