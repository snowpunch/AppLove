//
//  ReviewLoadManager.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Mass Multi-threaded page loader that can be safely canceled.
//  

import UIKit

class ReviewLoadManager: NSObject, ProgressDelegate {
    static let sharedInst = ReviewLoadManager()
    private override init() {} // enforce singleton
    
    var reviews = [ReviewModel]()
    var loadStates = [String:LoadState]() // loading state for every territory.
    var loadingQueue:NSOperationQueue?
    var firstQuickUpdate:Bool = false

    func initializeLoadingStates() {
        self.loadStates.removeAll()
        let territories = TerritoryMgr.sharedInst.getSelectedCountryCodes()
        for code in territories {
            self.loadStates[code] = LoadState(territory: code)
        }
        self.firstQuickUpdate = false
    }
    
    func loadReviews() {
        clearReviews()
        initializeLoadingStates()
        self.loadingQueue = nil
        self.loadingQueue = NSOperationQueue()
        self.loadingQueue?.maxConcurrentOperationCount = 4
        setNotifications()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Const.loadStart, object: nil)
        
        let countryCodes = TerritoryMgr.sharedInst.getSelectedCountryCodes()
        
        let allOperationsFinishedOperation = NSBlockOperation() {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Const.allLoadingCompleted, object: self)
            nc.postNotificationName(Const.displayToolbar, object: self)
        }
        
        if let appId = AppList.sharedInst.getSelectedModel()?.appId {
            for code in countryCodes {
                let pageInfo = PageInfo(appId: appId, territory: code)
                let operation = TerritoryLoadOperation(pageInfo: pageInfo)
                operation.delegate = self
                allOperationsFinishedOperation.addDependency(operation)
                self.loadingQueue?.addOperation(operation)
            }
        }
        
        NSOperationQueue.mainQueue().addOperation(allOperationsFinishedOperation)
    }
    
    // ProgressDelegate - update bar territory
    func territoryLoadCompleted(country:String) {
        //print("territoryLoadCompleted "+country)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let data:[String:AnyObject] = ["territory":country]
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Const.territoryDone, object:nil, userInfo:data)
        })
    }
    
    // ProgressDelegate - update bar territory
    func territoryLoadStarted(country:String) {
        //print("territoryLoadStarted "+country)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let data:[String:AnyObject] = ["territory":country]
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Const.territoryStart, object:nil, userInfo:data)
        })
    }
    
    // ProgressDelegate - update bar territory
    func pageLoaded(territory:String, reviews:[ReviewModel]?) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            if reviews == nil {
                if let loadState = self.loadStates[territory] {
                    loadState.error = true
                }
                let data:[String:AnyObject] = ["error":"error","territory":territory]
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(Const.dataError, object:nil, userInfo:data)
            }
            
            if let newReviews = reviews {
                if newReviews.count > 0 {
                    self.reviews.appendContentsOf(newReviews)
                }
                
                if let loadState = self.loadStates[territory] {
                    loadState.count += newReviews.count
                    loadState.error = false
                }
                
                if let loadState = self.loadStates[territory] {
                    loadState.error = false
                    let data:[String:AnyObject] = ["loadState":loadState,"territory":territory]
                    let nc = NSNotificationCenter.defaultCenter()
                    nc.postNotificationName(Const.updateAmount, object:nil, userInfo:data)
                }
                
                if self.firstQuickUpdate == false && self.reviews.count > 99 {
                    self.updateTable()
                }
            }
        })
    }
    
    func updateTable() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Const.reloadData, object: self)
        self.firstQuickUpdate = true
    }
    
    func setNotifications() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
        nc.addObserver(self, selector: .updateTableData, name: Const.allLoadingCompleted, object: nil)
    }
    
    func updateTableData(notification: NSNotification) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Const.reloadData, object: self)
    }
    
    func clearReviews() {
        reviews.removeAll()
        loadStates.removeAll()
    }
    
    func cancelLoading() {
        self.loadingQueue?.cancelAllOperations()
    }
}

private extension Selector {
    static let updateTableData = #selector(ReviewLoadManager.updateTableData(_:))
}
