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
import StoreKit

class ReviewListViewController: UIViewController {
    
    var allReviews = [ReviewModel]()
    var refreshControl: UIRefreshControl!
    @IBOutlet var tableView: UITableView!
    
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
        ReviewLoadManager.sharedInst.loadReviews()
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
        ReviewLoadManager.sharedInst.loadReviews()
        self.refreshControl?.endRefreshing()
    }
    
    func finishedRefreshing() {
        if CacheManager.sharedInst.ignore == true {
            CacheManager.sharedInst.stopIgnoringCache()
        }
    }
    
    func registerNotifications() {
        NSNotificationCenter.addObserver(self, sel: .reloadData, name: Const.load.reloadData)
        NSNotificationCenter.addObserver(self, sel: .displayToolbar, name: Const.load.displayToolbar)
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
    
//    @IBAction func onStopLoadToggle(button: UIBarButtonItem) {
//        if button.title == "Stop" {
//            stopButtonPressed()
//        }
//        else if button.title == "Load" {
//            loadButtonPressed()
//        }
//    }
    
    @IBAction func onSort(sender: UIBarButtonItem) {
        displaySortActionSheet(sender)
    }
    
//    @IBAction func onOptions(sender: UIBarButtonItem) {
//        displayOptionsActionSheet(sender)
//    }

//    func stopButtonPressed() {
//        ReviewLoadManager.sharedInst.cancelLoading()
//        NSNotificationCenter.post(Const.load.reloadData)
//        finishedRefreshing()
//    }
//    
//    func loadButtonPressed() {
//        ReviewLoadManager.sharedInst.loadReviews()
//    }
    
    
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

// action sheets
extension ReviewListViewController {
    
    func displaySortActionSheet(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let ratingSortAction = UIAlertAction(title: "Sort by Rating", style: .Default) { action -> Void in
            self.allReviews.sortInPlace({ $0.rating > $1.rating })
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPointZero, animated:true)
            })
        }
        let versionSortAction = UIAlertAction(title: "Sort by Version", style: .Default) { action -> Void in
            self.allReviews.sortInPlace({ $0.version > $1.version })
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPointZero, animated:true)
            })
        }
        let territorySortAction = UIAlertAction(title: "Sort by Territory", style: .Default) { action -> Void in
            self.allReviews.sortInPlace({ $0.territory < $1.territory })
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPointZero, animated:true)
            })
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(ratingSortAction)
        alertController.addAction(versionSortAction)
        alertController.addAction(territorySortAction)
        alertController.addAction(actionCancel)
        Theme.alertController(alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func removeEmptyTerritories(button: UIBarButtonItem){
        let alertController = UIAlertController(title: "Territory Options", message: "To hand pick territories use the side menu.", preferredStyle: .ActionSheet)

        let loadAllAction = UIAlertAction(title: "Load All Territories", style: .Default) { action -> Void in
            TerritoryMgr.sharedInst.selectAllTerritories()
            self.refresh("")
        }

        let loadDefaultAction = UIAlertAction(title: "Load Default Territories", style: .Default) { action -> Void in
            let defaultTerritories = TerritoryMgr.sharedInst.getDefaultCountryCodes()
            TerritoryMgr.sharedInst.setSelectedTerritories(defaultTerritories)
            self.refresh("")
        }
        
        let removeEmptyAction = UIAlertAction(title: "Remove Empty Territories", style: .Destructive) { action -> Void in
            let nonEmptyTeritories = ReviewLoadManager.sharedInst.getNonEmptyTerritories()
            TerritoryMgr.sharedInst.setSelectedTerritories(nonEmptyTeritories)
            self.refresh("")
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        alertController.addAction(loadAllAction)
        alertController.addAction(loadDefaultAction)
        alertController.addAction(removeEmptyAction)
        alertController.addAction(actionCancel)
        Theme.alertController(alertController)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

// app store
extension ReviewListViewController: SKStoreProductViewControllerDelegate {

    func showStore(id:Int) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier :
            NSNumber(integer: id)]
        storeViewController.loadProductWithParameters(parameters,
            completionBlock: {result, error in
                if result {
                    self.presentViewController(storeViewController,
                        animated: true, completion: nil)
                    // remove loading animation
                }
        })
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

private extension Selector {
    static let refresh = #selector(ReviewListViewController.refresh(_:))
    static let reloadData = #selector(UITableView.reloadData)
    static let displayToolbar = #selector(ReviewListViewController.displayToolbar)
}