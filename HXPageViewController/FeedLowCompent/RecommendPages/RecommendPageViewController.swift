//
//  RecommendPageViewController.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/18.
//  Copyright © 2019 WHX. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit

let cellClsNameBase = "UITableViewCell"
let identifierBase = "RecommendPageViewController_\(cellClsNameBase)"

let headlineCellIdentifity = "headlineCellIdentifity"
let cailianCellIdentifity = "cailianlistCellIdentifity"
let contentCellIdentifity = "contentCellIdentifity"

let headlineViewTag = 1001
let cailianViewTag = headlineViewTag + 1

enum CellType {
    case CarouselMap
    case RightPicture
    case LeftPicture
    case BigPicture
    case NonePicture
    case ThreePicture
}

struct CellModel {
    var text:String
    var date:String
    var souce:String
    var numberOfComments:CGFloat
    var imgData:Data?
    var type:CellType!
}

class RecommendPageViewController: UIViewController {
    
    lazy var dataCenter:FeedLowDataCenter  = {
        let center = FeedLowDataCenter()
        center.complete = complete
        return center
    }()
    
    lazy var headlineView:LLCycleScrollView = {
        var headlineView = LLCycleScrollView.llCycleScrollViewWithFrame(.zero)
        headlineView.lldidSelectItemAtIndex = { (index) in
            print("当前点击文本的位置为 headLine:\(index)")
        }
        headlineView.tag = headlineViewTag
        return headlineView
    }()
    
    lazy var cailianView:LLCycleScrollView = {
        var cailianView = LLCycleScrollView.llCycleScrollViewWithFrame(.zero)
        cailianView.lldidSelectItemAtIndex = { (index) in
            print("当前点击文本的位置为 cailian:\(index)")
        }
        cailianView.customPageControlStyle = .none
        cailianView.titleLeading = 30
        cailianView.numberOfLines = 2
        cailianView.scrollDirection = .vertical
        cailianView.tag = cailianViewTag
        return cailianView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NSClassFromString(cellClsNameBase), forCellReuseIdentifier: identifierBase)
        tableView.register(NSClassFromString(cellClsNameBase), forCellReuseIdentifier: headlineCellIdentifity)
        tableView.register(NSClassFromString(cellClsNameBase), forCellReuseIdentifier: cailianCellIdentifity)
        
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

//todo xiaofengmin datacenter
extension RecommendPageViewController {
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

extension RecommendPageViewController {
}

extension RecommendPageViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        switch section {
        case 0:
            number = dataCenter.headlineList.count > 0 ? 1:0
        case 1:
            number = dataCenter.cailianlist.count > 0 ? 1:0
        case 2:
            number = dataCenter.contentlist.count
            
        default:
            number = 0
        }
        return number
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headlineCellIdentifity)!
            if let _ = cell.viewWithTag(headlineViewTag) {} else {
                cell.contentView.addSubview(headlineView)
                
                headlineView.snp.makeConstraints { (maker) in
                    maker.left.right.bottom.top.equalToSuperview()
                }
                
            }
            
            let headlist = dataCenter.headlineList
            var titleList = [String]()
            var imgPaths = [String]()
            for headModel in headlist {
                titleList.append(headModel.title ?? "")
                imgPaths.append(headModel.img ?? "")
            }
            
            headlineView.imagePaths = imgPaths
            headlineView.titles = titleList
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cailianCellIdentifity)!
            
            if let _ = cell.viewWithTag(cailianViewTag) {} else {
                cell.addSubview(cailianView)
                
                cailianView.snp.makeConstraints { (maker) in
                    maker.width.height.top.equalToSuperview()
                }
//                cailianView.frame = CGRect(x: 0, y: 0, width: 300, height: )
                cailianView.backgroundColor = .red
                
            }
            
            let cailianList = dataCenter.cailianlist
            var titleList = [String]()
            
            for cailianModel in cailianList {
                titleList.append(cailianModel.title ?? "")
            }
            
            cailianView.titles = titleList
            
            return cell
        case 2:
            let model = dataCenter.contentlist[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierBase)!
            cell.textLabel?.text = model.title
            cell.imageView?.image = nil
            cell.detailTextLabel?.text = nil
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierBase)!
            return cell
        }
    }
}


extension RecommendPageViewController {
    public static func getImgData() -> Data! {
        let img = UIImage(named: "test_img")
        let data = img?.pngData()
        return data ?? Data()
    }
}
