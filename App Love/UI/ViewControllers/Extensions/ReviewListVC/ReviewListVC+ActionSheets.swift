//
//  ReviewListVC+ActionSheets.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit

// action sheets
extension ReviewListVC {
    
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