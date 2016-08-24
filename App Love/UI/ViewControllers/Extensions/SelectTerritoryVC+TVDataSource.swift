//
//  SelectCountryExtension.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-17.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Table for selecting which territories to download from.
//

import UIKit

extension SelectTerritoryVC {
    
    func tableSetup() {
        self.tableView.allowsMultipleSelection = true;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath) as! CountrySelectCell
        let model = countries[indexPath.row]
        cell.setup(model)
        return cell
    }
    
    // add territory
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CountrySelectCell
        cell.addSwitch.setOn(true, animated: true)
        countries[indexPath.row].isSelected = true
    }
    
    // remove territory
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CountrySelectCell
        cell.addSwitch.setOn(false, animated: true)
        countries[indexPath.row].isSelected = false
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
}