//
//  TerritoryLoadOperation.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Note: I don't recommend using semaphores in general. They were used
//  here in a small personal project just to get a stronger sense of them.
//
//  NSOperation to load up to 10 pages of a single territory.
//

import UIKit

protocol ProgressDelegate : class {
    func territoryLoadStarted(country:String)
    func pageLoaded(country:String, reviews:[ReviewModel]?)
    func territoryLoadCompleted(country:String)
}

class TerritoryLoadOperation: NSOperation {

    let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
    weak var delegate:ProgressDelegate?
    var finishedOperation = false
    var loader:LoadReviews?
    var pageInfo:PageInfo

    init(pageInfo:PageInfo) {
        self.pageInfo = pageInfo
    }

    override func main() {
        if cancelled {
            dispatch_semaphore_signal(self.semaphore)
            return
        }
        
        self.delegate?.territoryLoadStarted(self.pageInfo.territory)
        doNextPageLoad() // star recursive process.

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) // wait for signal
    }
    
    override func cancel() {
        finishOperation()
    }
    
    func finishOperation() {
        guard finishedOperation == false else { return }

        finishedOperation = true
        self.delegate?.territoryLoadCompleted(self.pageInfo.territory)
        if let loader = self.loader {
            loader.cancel()
        }
        dispatch_semaphore_signal(self.semaphore)
    }
    
    func doNextPageLoad() {
        guard finishedOperation == false else { return }
        
        self.loader = LoadReviews()
        self.pageInfo.page += 1
        
        loader!.loadAppReviews(pageInfo) {
            (reviews, succeeded, error, maxPages) -> Void in
            
            guard self.finishedOperation == false else { return }

            if succeeded == false {
                if self.pageInfo.preferJSON == true {
                    print("\(self.pageInfo.territory) failed json, tring again with xml url")
                    self.pageInfo.page -= 1
                    if let delegate = self.delegate  {
                        delegate.pageLoaded(self.pageInfo.territory, reviews: nil)
                    }
                    self.pageInfo.preferJSON = false
                    self.doNextPageLoad()
                }
                else {
                    print("too much failure")
                    self.finishOperation()
                }
                return
            }
            else
            {
                if let delegate = self.delegate  {
                    delegate.pageLoaded(self.pageInfo.territory, reviews: reviews)
                }
            }
            
            // more reviews to load for this territory
            if reviews?.count == 50 && self.pageInfo.page < maxPages && self.finishedOperation == false {
                self.doNextPageLoad()
                return
            }
            
            self.finishOperation()
        }
    }
}
