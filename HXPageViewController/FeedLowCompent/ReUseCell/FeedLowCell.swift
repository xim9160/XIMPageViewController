//
//  FeedLowCell.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit

class FeedLowImgCell: UITableViewCell{
    
    var titleLabel:UILabel = UILabel.init()
    var imgView:UIImageView = UIImageView.init()
    
    var tagLabel:UILabel = UILabel.init()
    
    var sourceLabel:UILabel = UILabel.init()
    
    ///评论或者点赞数量
    var commentLabel:UILabel = UILabel.init()
    
    ///日期
    var dateLabel:UILabel = UILabel.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configSubviews()
        
        self.setNeedsLayout()
        self.setNeedsUpdateConstraints()
        
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        
        configSubviews()
    }
    
    func configSubviews() {
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(imgView)
        //        self.contentView.addSubview(tagLabel)
        self.contentView.addSubview(sourceLabel)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(dateLabel)
        
        
        //todo init with Color
        HomePageCellConfig.configTitle(titleLabel)
        HomePageCellConfig.configSubLabels(sourceLabel, commentLabel, dateLabel)
        HomePageCellConfig.configImage(imgView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        imgView.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(HomePageCellConfig.base_offset_right)
            maker.top.equalToSuperview().offset(HomePageCellConfig.img_top)
            maker.width.equalTo(HomePageCellConfig.img_width)
            maker.height.equalTo(HomePageCellConfig.img_height)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left)
            maker.right.equalTo(imgView.snp_left).offset(HomePageCellConfig.label_right_img)
            maker.top.equalToSuperview().offset(HomePageCellConfig.label_top)
            maker.height.lessThanOrEqualTo(HomePageCellConfig.titleLabel_max_height)
        }
        
        sourceLabel.snp.makeConstraints { (maker) in
            //            maker.left.equalTo(tagLabel.snp_right).offset(HomePageCellConfig.sub_text_sep).priorityHigh()
            maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left)
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
        }
        
        commentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(sourceLabel.snp_right).offset(HomePageCellConfig.sub_text_sep)
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(commentLabel.snp_right).offset(HomePageCellConfig.sub_text_sep).priorityHigh()
            maker.left.equalTo(sourceLabel.snp_right).offset(HomePageCellConfig.base_offset_left).priorityMedium()
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
            maker.right.lessThanOrEqualTo(titleLabel.snp_right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FeedLowTitleCell: UITableViewCell {
    
    var titleLabel:UILabel = UILabel.init()
    var imgView:UIImageView = UIImageView.init()
    
    var tagLabel:UILabel = UILabel.init()
    
    var sourceLabel:UILabel = UILabel.init()
    
    ///评论或者点赞数量
    var commentLabel:UILabel = UILabel.init()
    
    ///日期
    var dateLabel:UILabel = UILabel.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(tagLabel)
        self.contentView.addSubview(sourceLabel)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(dateLabel)
        
        self.setNeedsUpdateConstraints()
        
        configSubviews()
    }
    
    func configSubviews() {
        //todo init with Color
        HomePageCellConfig.configTitle(titleLabel)
        HomePageCellConfig.configSubLabels(sourceLabel, commentLabel, dateLabel)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //                imgView.snp.makeConstraints { (maker) in
        //                    maker.right.equalToSuperview().offset(HomePageCellConfig.base_offset_right)
        //                    maker.top.equalToSuperview().offset(HomePageCellConfig.img_top)
        //                    maker.width.equalToSuperview().offset(HomePageCellConfig.img_width)
        //                    maker.width.equalToSuperview().offset(HomePageCellConfig.img_height)
        //                }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left)
            maker.right.equalToSuperview().offset(HomePageCellConfig.label_right_img)
            maker.top.equalToSuperview().offset(HomePageCellConfig.label_top)
            maker.height.lessThanOrEqualTo(HomePageCellConfig.titleLabel_max_height)
        }
        
        //        tagLabel.snp.makeConstraints { (maker) in
        //            maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left)
        //            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
        //            maker.height.equalTo(HomePageCellConfig.title_font)
        //        }
        
        sourceLabel.snp.makeConstraints { (maker) in
            //            maker.left.equalTo(tagLabel.snp_right).offset(HomePageCellConfig.sub_text_sep).priorityHigh()
            maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left).priorityMedium()
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
        }
        
        commentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(sourceLabel.snp_right).offset(HomePageCellConfig.sub_text_sep)
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(commentLabel.snp_right).offset(HomePageCellConfig.sub_text_sep).priorityHigh()
            maker.left.equalTo(sourceLabel.snp_right).offset(HomePageCellConfig.base_offset_left).priorityMedium()
            maker.height.equalTo(HomePageCellConfig.sub_text_font)
            maker.bottom.equalToSuperview().offset(HomePageCellConfig.sub_text_bottom)
            maker.right.lessThanOrEqualTo(titleLabel.snp_right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
