//
//  SelectCountryViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Select which territories to download from.
// 

import UIKit

class SelectCountryViewController: UITableViewController {

    let countries = TerritoryMgr.sharedInst.getArrayOfModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSetup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TerritoryMgr.sharedInst.updateFromTableState(self.countries)
    }
    
    @IBAction func onToggleSelectAll(sender: UIBarButtonItem) {
        if sender.title == "ALL" {
            sender.title = "CLEAR"
            selectAll() // toggle
        }
        else {
            sender.title = "ALL"
            clearAll() // toggle
        }
        self.tableView.reloadData()
    }
    
    func clearAll() {
        for country in countries {
            country.isSelected = false
        }
    }
    
    func selectAll() {
        for country in countries {
            country.isSelected = true
        }
    }
}