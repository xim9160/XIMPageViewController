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
import Kingfisher

let cellClsNameBase = "UITableViewCell"
let identifierBase = "RecommendPageViewController_\(cellClsNameBase)"

let headlineCellIdentifity = "headlineCellIdentifity"
let cailianCellIdentifity = "cailianlistCellIdentifity"
let contentCellImgIdentifity = "contentCellImgIdentifity"
let contentCellTitleIdentifity = "contentCellTitleIdentifity"

let headlineViewTag = 1001
let cailianViewTag = headlineViewTag + 1

//todo xiaofengmin to remove
let oneLineHeight = HomePageCellConfig.height("")


/// 下面两个为了后续 更多样式 预留
/*
enum CellType {
    case CarouselMap
    case RightPicture
    case LeftPicture
    case BigPicture
    case NonePicture
    case ThreePicture
}*/

/*
struct CellModel {
    var text:String
    var date:String
    var souce:String
    var numberOfComments:CGFloat
    var imgData:Data?
    var type:CellType!
}*/

class RecommendPageViewController: UIViewController {
    
    lazy var dataCenter:FeedLowDataCenter  = {
        let center = FeedLowDataCenter()
        center.complete = complete
        return center
    }()
    
    lazy var headlineView:LLCycleScrollView = {
        var headlineView = LLCycleScrollView.llCycleScrollViewWithFrame(.zero)
        headlineView.layer.cornerRadius = 4
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
            //todo xiaofengmin UI 这一块看接口
//            number = dataCenter.cailianlist.count > 0 ? 1:0
            return 0
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
                    maker.left.equalToSuperview().offset(HomePageCellConfig.base_offset_left)
                    maker.right.equalToSuperview().offset(HomePageCellConfig.base_offset_right)
                    maker.top.equalToSuperview().offset(HomePageCellConfig.headLine_top)
                    maker.bottom.equalToSuperview().offset(HomePageCellConfig.headLine_bottom)
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
            let model = dataCenter.contentlist[safe:indexPath.row]
//            model.
            //todo xiaofengmin 1/2 调试时使用, 具体接口给出后规则需要变更
            let withImg = indexPath.row % 2
            
            if withImg == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: contentCellImgIdentifity) as! FeedLowImgCell
                cell.imgView.kf.setImage(with: URL(string:model?.images?[safe:0] ?? ""))
                cell.titleLabel.text = model?.title
                cell.tagLabel.removeFromSuperview()//暂时不支持
                cell.sourceLabel.text = model?.authorName
//todo xiaofengmin 阅读数量, 评论数量 点赞数量, 规则需要处理下
                cell.commentLabel.text = "\(Int(model?.watchNum ?? 0))阅"
                cell.dateLabel.text = model?.descriptionTime
                
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: contentCellTitleIdentifity) as! FeedLowTitleCell
                cell.titleLabel.text = model?.title
                cell.tagLabel.removeFromSuperview()//暂时不支持
                cell.sourceLabel.text = model?.authorName
                //todo xiaofengmin 阅读数量, 评论数量 点赞数量, 规则需要处理下
                cell.commentLabel.text = "\(Int(model?.watchNum ?? 0))阅"
                cell.dateLabel.text = model?.descriptionTime
                return cell
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierBase)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return HomePageCellConfig.headLine_height
        case 1:
            return HomePageCellConfig.cell_height
        case 2:
            //todo xiaofengmin
            let withImg = indexPath.row % 2
            let model = dataCenter.contentlist[safe: indexPath.row]
            if withImg == 1 {
                return HomePageCellConfig.cell_height
            } else {
                let labelheight = HomePageCellConfig.height(model?.title ?? "")
                if labelheight > oneLineHeight + 1 {
                    return HomePageCellConfig.cell_height
                } else {
                    return HomePageCellConfig.cell_height_one_line
                }
            }
        default:
            return HomePageCellConfig.cell_height
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
