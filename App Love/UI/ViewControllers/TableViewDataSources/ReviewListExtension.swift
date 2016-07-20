//
//  ReviewListExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-04.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for App Reviews. Includes headerCell.
//  

import UIKit

extension ReviewListViewController: UITableViewDataSource {
    
    func tableSetup() {
        self.tableView.registerNib(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCellID")
        self.tableView.registerNib(UINib(nibName: "ReviewHeaderCell", bundle: nil), forCellReuseIdentifier: "ReviewHeaderCellID")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.estimatedSectionHeaderHeight = 90;
        self.tableView.delegate = self
    }
    
    func updateHeaderPosition() {
        let offset = CGPoint(x: self.tableView.contentOffset.x,y: self.tableView.contentOffset.y+1)
        self.tableView.setContentOffset(offset, animated:true)
    }

    func reloadData() {
        allReviews = ReviewLoadManager.sharedInst.reviews
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.updateHeaderPosition()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCellID", forIndexPath: indexPath) as! ReviewCell
        let model = self.allReviews[indexPath.row]
        cell.setup(model)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allReviews.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: UITableViewDelegate

extension ReviewListViewController: UITableViewDelegate {
    // header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView?
        
        if let headerCell = self.tableView.dequeueReusableCellWithIdentifier("ReviewHeaderCellID") as? ReviewHeaderCell,
            let appModel = AppList.sharedInst.getSelectedModel() {
            headerCell.setup(appModel)
            
            headerView = headerCell
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
}