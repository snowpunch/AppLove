//
//  ReviewListViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Display reviews for an app, for every territory selected.
// 

import UIKit


private extension Selector {
    static let refresh = #selector(ReviewListVC.refresh(_:))
    static let reloadData = #selector(UITableView.reloadData)
    static let displayToolbar = #selector(ReviewListVC.displayToolbar)
    static let onReviewOptions = #selector(ReviewListVC.onReviewOptions)
    static let finishedLoading = #selector(ReviewListVC.finishedLoading)
    static let updateLoadingCount = #selector(ReviewListVC.updateLoadingCount)
    static let startLoading = #selector(ReviewListVC.startLoading)
}

class ReviewListVC: UIViewController {
    
    var allReviews = [ReviewModel]()
    var refreshControl: UIRefreshControl!
    @IBOutlet var tableView: UITableView!

    // Territory Loading CollectionView
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var aveRating: UILabel!
    @IBOutlet weak var territoryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        registerNotifications()
        addRefreshControl()
        
        if let toolbar = self.navigationController?.toolbar {
            Theme.toolBar(toolbar)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = AppList.sharedInst.getSelectedModel() {
            setupCollection()
            ReviewLoadManager.sharedInst.loadReviews()
        }
        else {
            showEmptyView()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ReviewLoadManager.sharedInst.cancelLoading()
    }

    func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: .refresh, forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }

    func refresh(sender:AnyObject) {
        ReviewLoadManager.sharedInst.cancelLoading()
        CacheManager.sharedInst.startIgnoringCache()
        allReviews.removeAll()
        self.tableView.reloadData()
        if let _ = AppList.sharedInst.getSelectedModel() {
            setupCollection()
            ReviewLoadManager.sharedInst.loadReviews()
            territoryCollection.reloadData()
        }
        else {
            showEmptyView()
        }
        self.refreshControl?.endRefreshing()
    }
    
    func finishedRefreshing() {
        if CacheManager.sharedInst.ignore == true {
            CacheManager.sharedInst.stopIgnoringCache()
        }
    }
    
    func onReviewOptions(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let model = dic["reviewModel"] as? ReviewModel else { return }
        guard let button = dic["button"] as? UIButton else { return }
        displayReviewOptions(model, button:button)
    }
    
    func registerNotifications() {
        NSNotificationCenter.addObserver(self, sel: .reloadData, name: Const.load.reloadData)
        NSNotificationCenter.addObserver(self, sel: .displayToolbar, name: Const.load.displayToolbar)
        NSNotificationCenter.addObserver(self,sel: .onReviewOptions, name: Const.reviewOptions.showOptions)
        NSNotificationCenter.addObserver(self,sel: .startLoading, name: Const.load.loadStart)
        NSNotificationCenter.addObserver(self, sel: .finishedLoading, name: Const.load.allLoadingCompleted)
        NSNotificationCenter.addObserver(self, sel: .updateLoadingCount, name:Const.load.updateAmount)
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func displayToolbar() {
        finishedRefreshing()
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        NSNotificationCenter.post(Const.load.orientationChange)
    }
    
    @IBAction func onSort(sender: UIBarButtonItem) {
        displaySortActionSheet(sender)
    }
    
    @IBAction func onAppStore(sender: AnyObject) {
        // show loading indicator.
        if let appId = AppList.sharedInst.getSelectedModel()?.appId {
            showStore(appId)
        }
    }
    
    @IBAction func onRemoveEmptyTerritories(button: UIBarButtonItem) {
        removeEmptyTerritories(button)
    }
    
    deinit {
        unregisterNotifications()
    }
}