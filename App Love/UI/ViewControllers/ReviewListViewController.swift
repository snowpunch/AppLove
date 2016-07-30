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
import MessageUI

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
        NSNotificationCenter.addObserver(self,sel:.onReviewOptions, name: Const.reviewOptions.showOptions)
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
    
    func onReviewOptions(notification: NSNotification) {
        
        guard let dic = notification.userInfo else { return }

//        guard let territory = dic["territory"] as? String else { return }
//        guard loaderPieces[territory] != nil else { return }
        guard let model = dic["reviewModel"] as? ReviewModel else { return }
        guard let button = dic["button"] as? UIButton else { return }
//        guard let box = loaderPieces[territory] else { return }
//        box.updateProgress(loadState)
        displayReviewOptions(model, button:button)
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

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
    
    //- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{ ... }
    
//    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
    

    func displayReviewOptions(model:ReviewModel, button:UIButton) {
        
        guard let title = model.title else { return }

//        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
//        {
//            print("ipad")
//        }
//        else {
//            print("iPhone)")
//        }
        
        let alertController = UIAlertController(title:nil, message: title, preferredStyle: .ActionSheet)
//        let addFlagAction = UIAlertAction(title: "Flag", style: .Default) { action -> Void in
//            model.flag = true;
//        }
//        let removeFlagAction = UIAlertAction(title: "Remove Flag", style: .Default) { action -> Void in
//            model.flag = false;
//        }

        let emailAction = UIAlertAction(title: "Email", style: .Default) { action -> Void in
            self.displayReviewEmail(model)
        }
        let translateAction = UIAlertAction(title: "Translate", style: .Default) { action -> Void in
            self.displayGoogleTranslationViaSafari(model)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
//        if model.flag == false {
//             alertController.addAction(addFlagAction)
//        }
//        else {
//            alertController.addAction(removeFlagAction)
//        }
        
        alertController.addAction(emailAction)
        alertController.addAction(translateAction)
        alertController.addAction(cancelAction)
        
        if let popOverPresentationController : UIPopoverPresentationController = alertController.popoverPresentationController {
            popOverPresentationController.sourceView                = button
            popOverPresentationController.sourceRect                = button.bounds
            popOverPresentationController.permittedArrowDirections = [.Right]
        }
        
//        if let popoverController = alertController.popoverPresentationController {
////            popoverController.barButtonItem = sender
//            let h = self.view.bounds.height/2
//            let w = self.view.bounds.width
//           popoverController.sourceRect = CGRect(x:w,y:h-100, width: 100,height: 100)
//            popoverController.sourceView = self.view
//            popoverController.permittedArrowDirections = [.Right]
//        }
        
        //Theme.alertController(alertController)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayGoogleTranslationViaSafari(model:ReviewModel) {
        guard let title = model.title else  { return }
        guard let reviewText = model.comment else  { return }
        
        let rawUrlStr = "http://translate.google.ca?text="+title + "\n" + reviewText
        if let urlEncoded = rawUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let url = NSURL(string: urlEncoded) {
            UIApplication.sharedApplication().openURL(url)
        }
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

extension ReviewListViewController: MFMailComposeViewControllerDelegate {
    
    func displayReviewEmail(model:ReviewModel) {
        if MFMailComposeViewController.canSendMail() {
            let reviewMailComposerVC = ReviewEmail.generateSingleReviewEmail(model)
            reviewMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(reviewMailComposerVC.navigationBar)
            self.presentViewController(reviewMailComposerVC, animated: true, completion: nil)
        }
    }
    
    func displayTaggedReviewsEmail(models:[ReviewModel]) {
        if MFMailComposeViewController.canSendMail() {
            let taggedReviewsMailComposerVC = ReviewEmail.generateTaggedReviewsEmail(models)
            taggedReviewsMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(taggedReviewsMailComposerVC.navigationBar)
            self.presentViewController(taggedReviewsMailComposerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

private extension Selector {
    static let refresh = #selector(ReviewListViewController.refresh(_:))
    static let reloadData = #selector(UITableView.reloadData)
    static let displayToolbar = #selector(ReviewListViewController.displayToolbar)
    static let onReviewOptions = #selector(ReviewListViewController.onReviewOptions)
}