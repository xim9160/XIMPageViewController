//
//  NewletterCell.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/24.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

public struct NewsletterConfig {
    static let headHeight:CGFloat = 36
    static let headFontSize = 12
    static let headFont = UIFont.systemFont(ofSize: 12)
    static let headFonColor = UIColor.init("999999")
    static let headBackColor = UIColor.init("f6f6f6")
    
    static let longLineColor = UIColor.init("eeeeee")
    static let longLineOffsetX:CGFloat = 19
    static let longLineWidth:CGFloat = 1
    
    static let dateColor = UIColor.init("FF6666")
    static let dateFont = UIFont.systemFont(ofSize: 12)
    
    static let pointColor = UIColor.init("FF6666")
    static let pointWidth:CGFloat = 6
    static let pointY:CGFloat = 16
    
    static let date2content:CGFloat = 10
    static let content2share:CGFloat = 12
    
    //可能要加粗
    static let titleColor = UIColor.init("222222")
    static let contentColor = UIColor.init("333333")
    
    // MARK: - content
    static let titleFontSize:CGFloat = 17
    
    static let titleFont = UIFont.boldSystemFont(ofSize: 17)
    static let contentFont = UIFont.systemFont(ofSize: 17)
    
    static let shareBtnHeight:CGFloat = 16
    static let stockCodeBtnHeight:CGFloat = 20
    
}

public class NewletterCell: UITableViewCell{
    var dateLabel = UILabel.init()
    
    var pointView = UIImageView.init()
    var longLineView = UIImageView.init()
    
    var ID:Int?
    //    var containerView = UIView.init() //边框 + 虚线
    
    var contentLabel = UILabel.init()
    
    var shareBtn = UIButton(type: .system)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configSubviews()
        
        self.setNeedsUpdateConstraints()
//        self.updateConstraintsIfNeeded()
    }
    
    func configSubviews() -> Void {
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(longLineView)
        self.contentView.addSubview(pointView)
        //        self.contentView.addSubview(containerView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(shareBtn)
        
        longLineView.backgroundColor = NewsletterConfig.longLineColor
        
        pointView.backgroundColor = NewsletterConfig.pointColor
        pointView.layer.cornerRadius = 3
        
        dateLabel.font = NewsletterConfig.dateFont
        dateLabel.textColor = NewsletterConfig.dateColor
        
        //加粗 和 其他 attribute 处理 //todo xiaofengmin
        contentLabel.font = NewsletterConfig.contentFont
        contentLabel.numberOfLines = 0
        contentLabel.textColor = NewsletterConfig.contentColor
        
        //sharBtn img
        shareBtn.backgroundColor = NewsletterConfig.dateColor
        
        
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        longLineView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(NewsletterConfig.longLineOffsetX)
            maker.width.equalTo(NewsletterConfig.longLineWidth)
        }
        
        pointView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(longLineView)
            maker.width.height.equalTo(NewsletterConfig.pointWidth)
            maker.top.equalTo(NewsletterConfig.pointY)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(longLineView.snp_right).offset(HomePageCellConfig.base_offset_left)
            maker.centerY.equalTo(pointView)
        }
        
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(longLineView.snp_right).offset(NewsletterConfig.longLineOffsetX)
            maker.right.equalToSuperview().offset(HomePageCellConfig.base_offset_right)
            maker.top.equalTo(dateLabel.snp_bottom).offset(NewsletterConfig.date2content)
            maker.height.lessThanOrEqualTo(2000).priorityRequired()
        }
        
        shareBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentLabel.snp_bottom).offset(NewsletterConfig.content2share)
            maker.width.height.equalTo(NewsletterConfig.shareBtnHeight)
            maker.right.bottom.equalToSuperview().offset(HomePageCellConfig.base_offset_right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
