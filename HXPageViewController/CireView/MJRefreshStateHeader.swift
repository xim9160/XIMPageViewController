//
//  MJRefreshStateHeader.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/25.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import MJRefresh
import SnapKit

class MJRefreshCireHeader:MJRefreshStateHeader {
    lazy var cireView:Cireview = { () -> Cireview in
        let v = Cireview()
        v.value = 0
        v.maximumValue = 1
        v.maxableVlaue = 0.9
        self.addSubview(v)
        return v
    }()
    
    override func prepare() {
        super.prepare()
        
        self.labelLeftInset = 20
        
        self.stateLabel.font = UIFont.systemFont(ofSize: 12)
        self.lastUpdatedTimeLabel.isHidden = true
        
        self.setTitle("下拉刷新…", for: .idle)
        self.setTitle("正在刷新…", for: .refreshing)
        self.setTitle("释放刷新…", for: .pulling)
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            cireView.value = pullingPercent
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        stateLabel.snp.updateConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().offset(22/2)
        }
        
        cireView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(16)
            maker.centerY.equalToSuperview()
            maker.right.equalTo(stateLabel.snp_left).offset(-6)
        }
    }
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                cireView.animation(start: false)
            case .pulling:
                cireView.animation(start: false)
            case .refreshing:
                cireView.animation(start: true)
            default:
                cireView.animation(start: false)
            }
        }
    }
    
}
