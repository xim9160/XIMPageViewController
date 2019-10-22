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

class FeedLowHomePageViewController: UIViewController {

    private let titles = ["推荐", "沪深", "港股", "美股", "7x24"]

    private lazy var searchBar: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    private lazy var pageTabBar: HXPageTabBar = {
        let pageTabBar = HXPageTabBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: UIScreen.main.bounds.width, height: 50))
        pageTabBar.dataSource = self
        pageTabBar.delegate = self
        return pageTabBar
    }()
    
    private lazy var pageTabBarMenu: UIView = {
        let v = UIView()
        v.backgroundColor = .orange
        return v
    }()
    
    private lazy var pageContainer: HXPageContainer = {
        let pageContainer = HXPageContainer()
//        pageContainer.scrollView.alwaysBounceHorizontal = true
        pageContainer.dataSource = self
        pageContainer.delegate = self
        return pageContainer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(pageContainer)
        pageContainer.didMove(toParent: self)
        view.addSubview(pageContainer.view)
        pageTabBar.contentScrollView = pageContainer.scrollView
        view.addSubview(pageTabBar)
        view.addSubview(pageTabBarMenu)
        view.addSubview(searchBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
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

// MARK: -  HXPageContainerDelegate, HXPageContainerDataSource
extension FeedLowHomePageViewController: HXPageContainerDelegate, HXPageContainerDataSource {
    
    func numberOfChildViewControllers(in pageContainer: HXPageContainer) -> Int {
        return titles.count
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, childViewContollerAt index: Int) -> UIViewController {
        if index == 0 {
            let detailVC = RecommendPageViewController()
            return detailVC
        } else {
            let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailVC.text = titles[index]
            return detailVC
        }
    }
    
    func defaultCurrentIndex(in pageContainer: HXPageContainer) -> Int {
        return 0
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, willTransition fromVC: UIViewController, toVC: UIViewController) {
        print("willTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, didFinishedTransition fromVC: UIViewController, toVC: UIViewController) {
        print("didFinishedTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, didCancelledTransition fromVC: UIViewController, toVC: UIViewController) {
        print("didCancelledTransition: \(pageContainer.currentIndex) fromVC: \(fromVC) toVC: \(toVC)")
    }
    
    func pageContainer(_ pageContainer: HXPageContainer, dragging fromIndex: Int, toIndex: Int, percent: CGFloat) {
        print("dragging: \(pageContainer.currentIndex) fromIndex: \(fromIndex) toIndex: \(toIndex) percent: \(percent)")
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
    
}
