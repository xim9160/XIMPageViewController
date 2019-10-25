//
//  NewsletterController.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/24.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import MJRefresh

class NewsletterController: UIViewController {
    
    static let cellIdentifity = "NewsletterController_contentCell"
    
    lazy var dataCenter:NewsletterDataCenter  = {
        let center = NewsletterDataCenter()
        center.complete = complete
        return center
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NewletterCell.self, forCellReuseIdentifier: NewsletterController.cellIdentifity)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        //todo xiaofengmin estimatedRowHeight
        tableView.estimatedRowHeight = 300
        
        weak var weakSelf = self
        let header = MJRefreshCireHeader.init(refreshingBlock: {
            weakSelf?.dataCenter.lastestPage()
        })
        
        let footer = MJRefreshCireFooter.init(refreshingBlock: {
            weakSelf?.dataCenter.nextPage()
        })
    
        tableView.mj_header = header
        tableView.mj_footer = footer
        
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        self.view.setNeedsUpdateConstraints()
        
        self.dataCenter.lastestPage()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.view)
        }
        
    }
    
}

extension NewsletterController {
    func complete(state:State, msg:String?) {
        switch state {
        case .success:
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.reloadData()
        case .fail:
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.reloadData()
            //alert other info
        case .noMoreData:
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshingWithNoMoreData()
            tableView.reloadData()
        }
    }
}

extension NewsletterController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataCenter.headList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let month = dataCenter.headList[safe:section] else { return 0 }
        guard let list = dataCenter.cailianlist[month] else { return 0 }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let month = dataCenter.headList[safe:indexPath.section] else { return UITableViewCell() }
        guard let list = dataCenter.cailianlist[month] else { return UITableViewCell() }
        guard let model = list[safe: indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsletterController.cellIdentifity) as! NewletterCell
        
        cell.dateLabel.text = model.time
        let attributeText = attributeStr(from: (model.brief ?? ""), with: (model.title ?? ""))
        cell.contentLabel.attributedText = attributeText
        cell.ID = model.ID
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let month = dataCenter.headList[safe:section] else { return nil }
        
        //todo xiaofengmin new view
        let view = UIView.init()
        view.backgroundColor = NewsletterConfig.headBackColor
        
        let label = UILabel.init()
        label.frame = CGRect(x: CGFloat(HomePageCellConfig.base_offset_left), y: 0, width: UIScreen.main.bounds.width, height: NewsletterConfig.headHeight)
        label.text = month
        label.font = NewsletterConfig.headFont
        label.textColor = NewsletterConfig.headFonColor
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsletterConfig.headHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NewsletterController {
    // MARK: - AttributeString
    func attributeStr(from content :String, with string:String) -> NSAttributedString {
        let str:NSMutableAttributedString=NSMutableAttributedString.init(string:content)
        guard let range = content.range(of: string) else { return str }
        str.addAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: NewsletterConfig.titleFontSize),
             NSAttributedString.Key.foregroundColor:NewsletterConfig.titleColor!],
                          range:content.toNSRange(range))
        return str

    }
}

extension String {

    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}
