//
//  DetailViewController.swift
//  HXPageViewController
//
//  Created by HongXiangWen on 2019/1/7.
//  Copyright © 2019年 WHX. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var text: String = "啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单啊发发大道附近考试款到发货看见爱上饭卡活动费卡上家 1好21就👌1金好金1金 回家环境👌就好久好久黄金色花交换机就我就是人家误会居委会认监委缓解危机如今而后王嘉尔好久好久很简单"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(text)")
        
        let red = CGFloat(arc4random() % 255) / 255
        let green = CGFloat(arc4random() % 255) / 255
        let blue = CGFloat(arc4random() % 255) / 255
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        titleLabel.text = text
        
        //todo xiaorengmin UILabel 自适应高度
        titleLabel.backgroundColor = .red
        
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
//        titleLabel.preferredMaxLayoutWidth = 100
        
//        titleLabel.snp.updateConstraints { (maker) in
//            maker.top.equalTo(200)
////            maker.topMargin
//            maker.centerX.equalToSuperview()
//            maker.height.lessThanOrEqualTo(10000).priority(.low)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("xim viewWillAppear: \(text)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("xim viewDidAppear: \(text)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("xim viewWillDisappear: \(text)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("xim viewDidDisappear: \(text)")
    }

    deinit {
        print("xim deinit: \(text)")
    }
    
}
