//
//  DemoMatchViewController.swift
//  HXPageViewController
//
//  Created by HongXiangWen on 2019/1/10.
//  Copyright © 2019年 WHX. All rights reserved.
//

import UIKit

let navigationHeight = UIApplication.shared.statusBarFrame.height + 44
let searchBarHeight = 44

public class FeedLowHomePageViewController: UIViewController {
    
    /// tabbar 显示的标题
    private var titles:[String] {
        get {
            return config.titles
        }
    }
    
    
    /// tabbar config
    private var config = FeedLowHomeChannelConfig()

    
    /// 搜索栏
    private lazy var searchBar: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    
    /// 顶部tabbar
    private lazy var pageTabBar: HXPageTabBar = {
        let pageTabBar = HXPageTabBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: UIScreen.main.bounds.width, height: 50))
        pageTabBar.dataSource = self
        pageTabBar.delegate = self
        return pageTabBar
    }()
    
    private lazy var pageTabBarMenu: UIButton = {
        let v = UIButton()
        v.backgroundColor = .orange
        v.addTarget(self, action: #selector(showChannelEditPage), for: .touchUpInside)
        return v
    }()
    
    private lazy var pageContainer: HXPageContainer = {
        let pageContainer = HXPageContainer()
//        pageContainer.scrollView.alwaysBounceHorizontal = true
        pageContainer.dataSource = self
        pageContainer.delegate = self
        return pageContainer
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addChild(pageContainer)
        pageContainer.didMove(toParent: self)
        view.addSubview(pageContainer.view)
        pageTabBar.contentScrollView = pageContainer.scrollView
        view.addSubview(pageTabBar)
        view.addSubview(pageTabBarMenu)
        view.addSubview(searchBar)
    }

    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override public func updateViewConstraints() {
        super.updateViewConstraints()
        
        searchBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(UIApplication.shared.statusBarFrame.height)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(searchBarHeight)
        }
        
        pageTabBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBar.snp_bottom)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view).offset(-searchBarHeight)
            maker.height.equalTo(searchBarHeight)
        }
        
        pageTabBarMenu.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(pageTabBar)
            maker.left.equalTo(pageTabBar.snp_right)
            maker.right.equalTo(self.view.snp_right)
        }
        
        pageContainer.view.snp.makeConstraints { (maker) in
            maker.top.equalTo(pageTabBar.snp_bottom)
            maker.left.right.bottom.equalTo(self.view)
        }
        
    }
    
    func reload(_ sender: Any) {
        pageTabBar.setSelectedIndex(0, shouldHandleContentScrollView: true)
    }
    
}


//MARK: - BUTTON EVENT
extension FeedLowHomePageViewController {
    
    @objc func showChannelEditPage() {
        //todo xiaofengmin 
        let topList = ChannelModelCreater.channelUntilModels(isTop: true, config.titles)
        let bottomList = ChannelModelCreater.channelUntilModels(isTop: false, config.hideTitles)
        
        let selectVC = ChannelEditController(topDataSource: topList, andBottomDataSource: bottomList)!
        weak var weakSelf = self
        selectVC.disAppearBlock = { (showList, hideList) in
            weakSelf?.config.saveConfig(modeles:showList as! [ChannelUnitModel])
            weakSelf?.config.reloadTitles()
            weakSelf?.pageContainer.reloadData()
            let index = weakSelf?.pageContainer.currentIndex
//            let tabIndex = weakSelf?.pageTabBar.selectedIndex
            weakSelf?.pageTabBar.setSelectedIndex(index ?? 0, shouldHandleContentScrollView: true)
            weakSelf?.pageTabBar.reloadData()
        }
        selectVC.chooseIndexBlock = {(index, showList, hideList) in
            print(index)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectVC, animated: true)
        
    }
}

// MARK: -  HXPageContainerDelegate, HXPageContainerDataSource
extension FeedLowHomePageViewController: HXPageContainerDelegate, HXPageContainerDataSource {
    
    func numberOfChildViewControllers(in pageContainer: HXPageContainer) -> Int {
        return titles.count
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, childViewContollerAt index: Int) -> UIViewController {
        //todo xiaofengmin 这里需要按照给定的接口进行处理
        let title = titles[safe:index] ?? "default"
        if let vc = config.controllers[title] {
            return vc
        } else {
            
            let defaultVc = UIViewController.init()
            
            let cls = config.map(title) as? UIViewController.Type
            let vcClass: AnyClass? = cls
            guard let typeClass = vcClass as? UIViewController.Type else {
                return defaultVc
            }
            let vc = typeClass.init()
            config.controllers[title] = vc
            
            return vc
        }
    }
    
    func defaultCurrentIndex(in pageContainer: HXPageContainer) -> Int {
        return 0
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, willTransition fromVC: UIViewController, toVC: UIViewController) {
//        print("xim willTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, didFinishedTransition fromVC: UIViewController, toVC: UIViewController) {
//        print("xim didFinishedTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, didCancelledTransition fromVC: UIViewController, toVC: UIViewController) {
//        print("xim didCancelledTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, dragging fromIndex: Int, toIndex: Int, percent: CGFloat) {
//        print("xim dragging: \(pageContainer.currentIndex) fromIndex: \(fromIndex) toIndex: \(toIndex) percent: \(percent)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, didSelected index: Int) {
        pageTabBar.setSelectedIndex(index, shouldHandleContentScrollView: true)
    }

}

// MARK: -  HXPageContainerDelegate, HXPageContainerDataSource
extension FeedLowHomePageViewController: HXPageTabBarDataSource, HXPageTabBarDelegate {
    
    func numberOfItems(in pageTabBar: HXPageTabBar) -> Int {
        return titles.count
    }
    
    func pageTabBar(_ pageTabBar: HXPageTabBar, titleForItemAt index: Int) -> String {
        return titles[index]
    }
    
    func defaultSelectedIndex(in pageTabBar: HXPageTabBar) -> Int {
        return 0
    }
    
    func colorForIndicatorView(in pageTabBar: HXPageTabBar) -> UIColor {
        return HomePageCellConfig.red_color
    }
    
    func titleColorForItem(in pageTabBar: HXPageTabBar) -> UIColor {
        return HomePageCellConfig.title_default_color!
    }
    
    
    func titleHighlightedFontForItem(in pageTabBar: HXPageTabBar) -> UIFont {
        return .boldSystemFont(ofSize: HomePageCellConfig.tabbar_title_font)
    }
    
    func titleFontForItem(in pageTabBar: HXPageTabBar) -> UIFont {
        return .italicSystemFont(ofSize: HomePageCellConfig.tabbar_title_font)
    }
    
    func titleHighlightedColorForItem(in pageTabBar: HXPageTabBar) -> UIColor {
        return HomePageCellConfig.title_color!
    }
    
    func pageTabBar(_ pageTabBar: HXPageTabBar, widthForIndicatorViewAt index: Int) -> CGFloat {
        return 16
    }
    
}
