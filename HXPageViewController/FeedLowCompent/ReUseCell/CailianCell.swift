//
//  CailianCell.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/24.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation

public class CailianCell: UITableViewCell{
    var dateLabel = UILabel.init()
    
    var topImgView = UIImageView.init()
    var longLineView = UIImageView.init()
    
    var containerView = UIView.init() //边框 + 虚线
    
    var titleLabel = UILabel.init()
    var contentLabel = UILabel.init()
    
    var shareBtn = UIButton(type: .system)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(topImgView)
        self.contentView.addSubview(longLineView)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(shareBtn)
        
        self.setNeedsLayout()
        self.setNeedsUpdateConstraints()
    }
    //todo xiaofengmin
    public override func updateConstraints() {
        <#code#>
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
