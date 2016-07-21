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
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(AppListViewController.onMenuClose)
    static let onMenuOpen = #selector(AppListViewController.onMenuOpen)
    static let onTerritoryOptions = #selector(AppListViewController.onTerritoryOptions)
    static let onLoadOptions = #selector(AppListViewController.onLoadOptions)
    static let onTranlateOptions = #selector(AppListViewController.onTranlateOptions)
    static let onShare = #selector(AppListViewController.onShare)
    static let onAskReview = #selector(AppListViewController.onAskReview)
    static let onAbout = #selector(AppListViewController.onAbout)
    static let onHelp = #selector(AppListViewController.onHelp)
}

class AppListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: HamburgerButton!
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        displayAppList()
        addObservers()
        initElasticTransitions()
        if let toolbar = self.navigationController?.toolbar {
            Theme.toolBar(toolbar)
        }

        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
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
    
    func addObservers() {
        NSNotificationCenter.addObserver(self, sel: .onMenuOpen, name: Const.sideMenu.openMenu)
        NSNotificationCenter.addObserver(self, sel: .onMenuClose, name: Const.sideMenu.closeMenu)
        NSNotificationCenter.addObserver(self, sel: .onTerritoryOptions, name: Const.sideMenu.territories)
        NSNotificationCenter.addObserver(self, sel: .onLoadOptions, name: Const.sideMenu.loadOptions)
        NSNotificationCenter.addObserver(self, sel: .onTranlateOptions, name: Const.sideMenu.translateOptions)
        NSNotificationCenter.addObserver(self, sel: .onShare, name: Const.sideMenu.share)
        NSNotificationCenter.addObserver(self, sel: .onAskReview, name: Const.sideMenu.askReview)
        NSNotificationCenter.addObserver(self, sel: .onHelp, name: Const.sideMenu.help)
        NSNotificationCenter.addObserver(self, sel: .onAbout, name: Const.sideMenu.about)
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
    
    func onLoadOptions() {
        displayElasticOptions("options")
    }
    
    func onTranlateOptions() {
        displayElasticOptions("options")
    }
    
    func onHelp() {
        elasticPresentViewController("help")
    }
    
    func onAbout() {
        elasticPresentViewController("about")
    }
    
    func onMenuOpen() {
        openElasticMenu()
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
    
    @IBAction func onShare(sender: AnyObject) {
        print("share stub")
    }
    
    func onTerritoryOptions(sender: AnyObject) {
        performSegueWithIdentifier("selectCountry", sender: nil)
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

// elastic extensions
extension AppListViewController {
    
    func initElasticTransitions(){
        transition.stiffness = 0.7
        transition.damping = 0.40
        transition.stiffness = 1
        transition.damping = 0.75
        transition.transformType = .TranslateMid
    }
    
    func displayElasticOptions(viewControlerId:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier(viewControlerId)
            aboutVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            transition.edge = .Bottom
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            transition.showShadow = true
            transition.transformType = .Rotate
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .Custom
            presentViewController(aboutVC, animated: true, completion: nil)
        }
    }
    
    func elasticPresentViewController(storyBoardID:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier(storyBoardID)
            transition.edge = .Right
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .Custom
            presentViewController(aboutVC, animated: true, completion: nil)
        }
    }
    
    func openElasticMenu() {
        transition.edge = .Left
        transition.startingPoint = CGPoint(x:30,y:70)
        transition.showShadow = false
        transition.transformType = .TranslateMid
        performSegueWithIdentifier("menu", sender: self)
    }
}

// write a review
extension AppListViewController {

    func doAppReview() {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1099336831";
        
        if let reviewURL =  NSURL(string:urlStr) {
            dispatch_async( dispatch_get_main_queue(),{
                UIApplication.sharedApplication().openURL(reviewURL);
            })
        }
    }
    
    func onAskReview(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "You're Awesome!", message: "Thank you helping this app.\nApp Love needs your feedback.", preferredStyle: .Alert)
        let addReviewAction = UIAlertAction(title: "add review", style: .Default) { action -> Void in
            self.doAppReview()
        }
        addReviewAction.setValue(UIImage(named: "heartplus"), forKey: "image")
        let addStarsAction = UIAlertAction(title: "or just tap stars", style: .Default) { action -> Void in
            self.doAppReview()
        }
        addStarsAction.setValue(UIImage(named: "rating"), forKey: "image")
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(addReviewAction)
        alertController.addAction(addStarsAction)
        alertController.addAction(cancelAction)
        //Theme.alertController(alertController)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
