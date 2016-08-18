//
//  AppListVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  The main view. Can reorder or delete apps.
//

import UIKit
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(AppListViewVC.onMenuClose)
    static let onMenuOpen = #selector(AppListViewVC.onMenuOpen)
}

class AppListViewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: HamburgerButton!
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        displayAppList()
        initElasticTransitions()
        addObservers()
        addMenuObservers()
        
        if let toolbar = self.navigationController?.toolbar {
            Theme.toolBar(toolbar)
        }
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
    }
    
    func addObservers() {
        NSNotificationCenter.addObserver(self, sel: .onMenuOpen, name: Const.sideMenu.openMenu)
        NSNotificationCenter.addObserver(self, sel: .onMenuClose, name: Const.sideMenu.closeMenu)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (SearchList.sharedInst.appModelDic.count > 0) {
            addAppsSelectedFromSearchResults()
        }
        
        if hamburgerButton.showsMenu == false {
            hamburgerButton.showsMenu = true
        }
        self.navigationController?.toolbarHidden = false
    }
    
    
    
    // apps to display initially, to check out how the app functions
    func loadDefaultApps () {
        let defaultAppIds = [Const.appId.MusketSmoke, Const.appId.AppLove]
        
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
    
    @IBAction func onSideMenuButton(button: HamburgerButton) {
        button.showsMenu = false // morphs to arrow
        onMenuOpen()
    }
    
    func onMenuClose() {
        hamburgerButton.showsMenu = true // morphs arrow back to menu button.
    }
    
    func displayAppList() {
        if (AppList.sharedInst.load() == false) {
            loadDefaultApps()
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
    
    func addSplitViewCollapseButton(segue:UIStoryboardSegue) {
        var destination = segue.destinationViewController
        if let nc = destination as? UINavigationController,
            let visibleVC = nc.visibleViewController {
            destination = visibleVC
            destination.navigationItem.leftBarButtonItem =
                self.splitViewController?.displayModeButtonItem()
            destination.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailReviews" {
            addSplitViewCollapseButton(segue)
            return
        }
        
        let vc = segue.destinationViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .Custom
    }
}

//// write a review
//extension AppListViewVC {
//    
//    func doAppReview() {
//        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1099336831";
//        
//        if let reviewURL =  NSURL(string:urlStr) {
//            dispatch_async( dispatch_get_main_queue(),{
//                UIApplication.sharedApplication().openURL(reviewURL);
//            })
//        }
//    }
//    
//    func onAskReview(sender: UIBarButtonItem) {
//        let alertController = UIAlertController(title: "You're Awesome!", message: "Thank you for helping this app.\nApp Love needs your feedback.", preferredStyle: .Alert)
//        let addReviewAction = UIAlertAction(title: "add review", style: .Default) { action -> Void in
//            self.doAppReview()
//        }
//        addReviewAction.setValue(UIImage(named: "heartplus"), forKey: "image")
//        let addStarsAction = UIAlertAction(title: "or just tap stars", style: .Default) { action -> Void in
//            self.doAppReview()
//        }
//        addStarsAction.setValue(UIImage(named: "rating"), forKey: "image")
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        alertController.addAction(addReviewAction)
//        alertController.addAction(addStarsAction)
//        alertController.addAction(cancelAction)
//        //Theme.alertController(alertController)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//}
//
//extension AppListViewVC: MFMailComposeViewControllerDelegate {
//    
//    func displayAppListComposerEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let appListMailComposerVC = AppListEmail.generateAppList()
//            appListMailComposerVC.mailComposeDelegate = self
//            Theme.mailBar(appListMailComposerVC.navigationBar)
//            self.presentViewController(appListMailComposerVC, animated: true, completion: nil)
//        }
//    }
//    
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
//    }
//}