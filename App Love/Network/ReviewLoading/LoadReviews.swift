//
//  LoadReviews.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-06.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads one page (0-50) reviews for one territory.
// 

import UIKit

class LoadReviews: NSObject {
    var task:NSURLSessionDataTask?
    
    func cancel() {
        if let _ = self.task {
            self.task?.cancel()
        }
    }
    
    func getPageUrl(pageInfo:PageInfo) -> String {
        var url = "https://itunes.apple.com/\(pageInfo.territory)/rss/customerreviews/page=\(pageInfo.page)/id=\(pageInfo.appId)/sortBy=mostRecent/"
        url += pageInfo.preferJSON ? "json" : "xml"
//        print("url:\(url)");
        return url
    }
    
    func loadAppReviews(pageInfo:PageInfo, completion: (reviews:[ReviewModel]?,succeeded: Bool, error:NSError?, maxPages:Int) -> Void) {
        
        let url = getPageUrl(pageInfo)
        
        if let reviews = CacheManager.sharedInst.getReviewsFromCache(url) {
            completion(reviews: reviews, succeeded: true , error: nil,maxPages: 10)
        }
        else {
            guard let nsurl = NSURL(string: url) else { return }
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(nsurl, completionHandler: { (data, response, error) in
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode,
                    let data = data else {
                        completion(reviews: nil, succeeded: false , error: error, maxPages: 0)
                        return
                }
                
                let allGood = (error == nil && statusCode == 200) // 403 means server blocked.
                
                if allGood {
                    let reviewsArray = ReviewParser(pageInfo: pageInfo).createModels(data)
                    CacheManager.sharedInst.addReviewsToCache(reviewsArray, url:url)
                    completion(reviews: reviewsArray, succeeded: true , error: nil,maxPages: 10)
                }
                else {
                    completion(reviews: nil, succeeded: false , error: error, maxPages: 0)
                }
            })
            task.resume()
        }
    }
}
