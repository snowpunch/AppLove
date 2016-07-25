//
//  AppListViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-31.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  The main view. Can reorder or delete apps.
//  

import UIKit

class AppListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        Theme.toolBar(toolBar)
        displayAppList()
//        BaseHttper()
    }
    
    func displayAppList() {
        if (AppList.sharedInst.load() == false) {
            loadDefaultApps()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (SearchList.sharedInst.appModelDic.count > 0) {
            addAppsSelectedFromSearchResults()
        }
    }
    
    func addAppsSelectedFromSearchResults() {
        let newApps = SearchList.sharedInst.getArray()
        AppList.sharedInst.appModels.appendContentsOf(newApps)
        SearchList.sharedInst.removeAll()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            AppList.sharedInst.save()
            self.tableView.reloadData()
        })
    }
    
    // apps to display initially, to check out how the app functions
    func loadDefaultApps () {
        let defaultAppIds = [Const.MusketSmoke, Const.AppLove]
        
        for appId:Int in defaultAppIds {
            AppInfo.get(String(appId)) { (model, succeeded, error) -> Void in
                
                // add an app model
                if let appModel = model {
                    AppList.sharedInst.addAppModel(appModel)
                }
                
                let finishedLoading = (defaultAppIds.count == AppList.sharedInst.appModels.count)
                if (finishedLoading)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        AppList.sharedInst.save()
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
 
    @IBAction func onQRCode(sender: AnyObject) {
        performSegueWithIdentifier("QRCode", sender: nil)
        
    }
    @IBAction func onSearch(sender: AnyObject) {
        performSegueWithIdentifier("AppSearch", sender: nil)
    }
   
    @IBAction func editMode(sender: UIBarButtonItem) {
        if (self.tableView.editing) {
            sender.title = "Edit"
            self.tableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func onAbout(sender: AnyObject) {
        
        let alertController:UIAlertController = UIAlertController(title: "About", message: "where did you want to go", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let action1:UIAlertAction = UIAlertAction(title: "AppList", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            self.performSegueWithIdentifier("AppList", sender: nil)
        }
        
        let action2:UIAlertAction = UIAlertAction(title: "about", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            if let storyboard = self.storyboard {
                let aboutVC = storyboard.instantiateViewControllerWithIdentifier("about")
                self.navigationController!.pushViewController(aboutVC, animated: true)
            }
        }
        let action3:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
}
