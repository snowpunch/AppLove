//
//  ReviewListVC+Refresh.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-22.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Pull down on reviews to refresh (reload data).
//

import UIKit

private extension Selector {
    static let refresh = #selector(ReviewListVC.refresh(_:))
}

extension ReviewListVC {
    
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
}