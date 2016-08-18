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
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var aveRating: UILabel!
    var lowestIndex = 0
    @IBOutlet weak var territoryCollection: UICollectionView!
    
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
        
        if let _ = AppList.sharedInst.getSelectedModel() {
            setupCollection()
            ReviewLoadManager.sharedInst.loadReviews()
        }
        else {
            showEmptyView()
        }
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
        if let _ = AppList.sharedInst.getSelectedModel() {
            setupCollection()
            ReviewLoadManager.sharedInst.loadReviews()
            territoryCollection.reloadData()
        }
        else {
            showEmptyView()
        }
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
        NSNotificationCenter.addObserver(self,sel: .onReviewOptions, name: Const.reviewOptions.showOptions)
        NSNotificationCenter.addObserver(self,sel: .startLoading, name: Const.load.loadStart)
        NSNotificationCenter.addObserver(self, sel: .finishedLoading, name: Const.load.allLoadingCompleted)
        NSNotificationCenter.addObserver(self, sel: .updateLoadingCount, name:Const.load.updateAmount)
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
    
    @IBAction func onSort(sender: UIBarButtonItem) {
        displaySortActionSheet(sender)
    }
    
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
        guard let model = dic["reviewModel"] as? ReviewModel else { return }
        guard let button = dic["button"] as? UIButton else { return }
        displayReviewOptions(model, button:button)
    }
    
    func scrollFlagsToEnd() {
        let finalPos =  ReviewLoadManager.sharedInst.loadStateArray.count - 1
        if finalPos > 0 {
            let path = NSIndexPath(forItem: finalPos, inSection: 0)
            if path != NSNotFound {
                territoryCollection.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            }
        }
    }

    func scrollFlagsToBeginning() {
        let finalPos =  0
        let path = NSIndexPath(forItem: finalPos, inSection: 0)
        territoryCollection.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func startLoading() {
        scrollFlagsToBeginning()
    }
    
    // scrollToEndWhenFinishedLoading
    func finishedLoading() {
        scrollFlagsToEnd()
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
    }
    
    func updateLoadingCount(notification: NSNotification) {
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Loading Reviews : "+String(totalReviewsLoaded)
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

    func displayReviewOptions(model:ReviewModel, button:UIButton) {
        
        guard let title = model.title else { return }
        let alertController = UIAlertController(title:nil, message: title, preferredStyle: .ActionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .Default) { action -> Void in
            self.displayReviewEmail(model)
        }
        let translateAction = UIAlertAction(title: "Translate", style: .Default) { action -> Void in
            self.displayGoogleTranslationViaSafari(model)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(emailAction)
        alertController.addAction(translateAction)
        alertController.addAction(cancelAction)
        
        if let popOverPresentationController : UIPopoverPresentationController = alertController.popoverPresentationController {
            popOverPresentationController.sourceView = button
            popOverPresentationController.sourceRect = button.bounds
            popOverPresentationController.permittedArrowDirections = [.Right]
        }

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
    static let finishedLoading = #selector(ReviewListViewController.finishedLoading)
    static let updateLoadingCount = #selector(ReviewListViewController.updateLoadingCount)
    static let startLoading = #selector(ReviewListViewController.startLoading)
}

extension ReviewListViewController: UICollectionViewDataSource {
    
    func showEmptyView() {
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        appName.text = "Select an App"
        aveRating.text = "on the left"
    }
    
    func setupCollection() {
        
        territoryCollection.delegate = self
        territoryCollection.dataSource = self
        territoryCollection.bounces = true
        territoryCollection.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        territoryCollection.registerClass(TerritoryLoadCell.self, forCellWithReuseIdentifier: "territoryLoadCell")
        territoryCollection.registerNib(UINib(nibName: "TerritoryLoadCell", bundle: nil), forCellWithReuseIdentifier: "territoryLoadCell")

        // App Info
        if let appModel = AppList.sharedInst.getSelectedModel(),
            let urlStr = appModel.icon100,
            let url =  NSURL(string:urlStr) {
            appIcon.sd_setImageWithURL(url, placeholderImage: UIImage(named:"defaulticon"))
            appName.text = appModel.appName
            let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
            aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
            territoryCollection.reloadData()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReviewLoadManager.sharedInst.loadStates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("territoryLoadCell", forIndexPath: indexPath) as! TerritoryLoadCell
        
        let loadState = ReviewLoadManager.sharedInst.loadStateArray[indexPath.row]
        
        cell.setup(loadState)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
}

extension ReviewListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let sideSize = CGSize(width: 26,height: 43)
        return sideSize;
    }
}