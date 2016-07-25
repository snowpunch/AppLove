//
//  AppSearchExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-04.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for search results. Can multi-select rows.
//

import UIKit

extension AppSearchViewController {
    
    func setTableStyle() {
        self.tableView.separatorStyle = .None
        self.tableView.allowsMultipleSelection = true;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppSelectCellID", forIndexPath: indexPath) as! AppSelectCell
        let model = self.apps[indexPath.row]
        cell.setup(model)
        return cell
    }
    
    // select app
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AppSelectCell
        cell.addSwitch.setOn(true, animated: true)
        let model = self.apps[indexPath.row]
        SearchList.sharedInst.addAppModel(model)
    }
    
    // deselect app
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AppSelectCell
        cell.addSwitch.setOn(false, animated: true)
        let model = self.apps[indexPath.row]
        SearchList.sharedInst.removeAppModel(model)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
}