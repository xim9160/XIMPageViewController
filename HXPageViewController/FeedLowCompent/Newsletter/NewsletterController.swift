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
    lazy var dataCenter:NewsletterDataCenter  = {
        let center = NewsletterDataCenter()
        center.complete = complete
        return center
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FeedLowImgCell.self, forCellReuseIdentifier: contentCellImgIdentifity)
        tableView.register(FeedLowTitleCell.self, forCellReuseIdentifier: contentCellTitleIdentifity)
        
        tableView.register(NSClassFromString(cellClsNameBase), forCellReuseIdentifier: headlineCellIdentifity)
        tableView.register(NSClassFromString(cellClsNameBase), forCellReuseIdentifier: cailianCellIdentifity)
        
        tableView.separatorStyle = .none
        
        weak var weakSelf = self
        let header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.dataCenter.lastestPage()
        })
        
        let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
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
        
        return UITableViewCell()
        //creatCell and Set Data

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let month = dataCenter.headList[safe:section] else { return nil }
        let label = UILabel.init()
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: HomePageCellConfig.headView_height)
        label.text = month
        
        return label
    }
    
    
}
