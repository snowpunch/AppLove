//
//  AppListVC+SideMenu.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Side Menu
//

import Foundation
import MessageUI

private extension Selector {
    static let onTerritoryOptions = #selector(AppListViewVC.onTerritoryOptions)
    static let onLoadOptions = #selector(AppListViewVC.onLoadOptions)
    static let onShare = #selector(AppListViewVC.onShare)
    static let onAskReview = #selector(AppListViewVC.onAskReview)
    static let onAbout = #selector(AppListViewVC.onAbout)
    static let onHelp = #selector(AppListViewVC.onHelp)
}

extension AppListViewVC {
    
    func addMenuObservers() {
        NSNotificationCenter.addObserver(self, sel: .onTerritoryOptions, name: Const.sideMenu.territories)
        NSNotificationCenter.addObserver(self, sel: .onLoadOptions, name: Const.sideMenu.loadOptions)
        NSNotificationCenter.addObserver(self, sel: .onShare, name: Const.sideMenu.share)
        NSNotificationCenter.addObserver(self, sel: .onAskReview, name: Const.sideMenu.askReview)
        NSNotificationCenter.addObserver(self, sel: .onHelp, name: Const.sideMenu.help)
        NSNotificationCenter.addObserver(self, sel: .onAbout, name: Const.sideMenu.about)
    }
    
    func onLoadOptions() {
        displayElasticOptions("loadOptions")
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
    
    func onTerritoryOptions(sender: AnyObject) {
        performSegueWithIdentifier("selectCountry", sender: nil)
    }
    
    func onShare(sender: AnyObject) {
        displayAppListComposerEmail()
    }
    
    func doAppReview() {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1099336831";
        
        if let reviewURL =  NSURL(string:urlStr) {
            dispatch_async( dispatch_get_main_queue(),{
                UIApplication.sharedApplication().openURL(reviewURL);
            })
        }
    }
    
    func onAskReview(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "You're Awesome!", message: "Thank you for helping this app.\nApp Love needs your feedback.", preferredStyle: .Alert)
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

extension AppListViewVC: MFMailComposeViewControllerDelegate {
    
    func displayAppListComposerEmail() {
        if MFMailComposeViewController.canSendMail() {
            let appListMailComposerVC = AppListEmail.generateAppList()
            appListMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(appListMailComposerVC.navigationBar)
            self.presentViewController(appListMailComposerVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}