//
//  AppListExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-04.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for main view. Can select, re-order or delete apps.
// 

import UIKit

extension AppListViewController: UITableViewDataSource {
    
    func initTableView() {
        let nib = UINib(nibName: "AppCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AppCellID")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 71
        self.tableView.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppCellID", forIndexPath: indexPath) as! AppCell
        let model = AppList.sharedInst.appModels[indexPath.row]
        cell.setup(model)
        return cell
    }
    
    // select row
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = AppList.sharedInst.appModels[indexPath.row]
        AppList.sharedInst.setSelectedModel(item)
        
        if let storyboard = self.storyboard {
            let reviewListVC = storyboard.instantiateViewControllerWithIdentifier("reviewList")
            showDetailViewController(reviewListVC, sender: self)
        }
        return indexPath
    }
    
    // delete row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            AppList.sharedInst.appModels.removeAtIndex(indexPath.row)
            AppList.sharedInst.save()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    // move row
    func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            let val = AppList.sharedInst.appModels.removeAtIndex(sourceIndexPath.row)
            AppList.sharedInst.appModels.insert(val, atIndex: destinationIndexPath.row)
            AppList.sharedInst.save()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppList.sharedInst.appModels.count;
    }
}