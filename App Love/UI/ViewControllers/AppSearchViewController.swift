//
//  AppSearchViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-27.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Multi-Select search results. Add more apps to your main list.
// 

import UIKit

class AppSearchViewController: UITableViewController, UISearchBarDelegate {

    var apps:[AppModel] = [AppModel]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableStyle()
        searchBar.delegate = self
        searchBar.placeholder = "ie: Musket Game";
        Theme.searchBar(searchBar)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        let searchStr = searchBar.text
        
        SearchApps.get(searchStr!) { (apps, succeeded, error) -> Void in

            if let appsFound = apps {
                self.apps = appsFound
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
}
