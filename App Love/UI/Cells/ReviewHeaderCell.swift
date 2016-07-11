//
//  ReviewHeaderCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Displays header in reviews table, showing what app you 
//  are looking at and also the LoadingProgressBar.
//  Warning: This gets called more than once and so the bar
//  needs to be able to reconstruct itself on the fly.
//  

import UIKit
import SpriteKit
import SDWebImage

private extension Selector {
    static let updateHeader = #selector(ReviewHeaderCell.updateHeader)
}

class ReviewHeaderCell: UITableViewCell {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    var loadingProgressBar:LoadingProgressBar?
    
    func setup(model:AppModel) {
        if let urlStr = model.icon100,
            let url =  NSURL(string:urlStr) {
                appIcon.sd_setImageWithURL(url, placeholderImage: UIImage(named:"defaulticon"))
        }
        
        self.appNameLabel.text = model.appName
        registerNotifications()
        addLoadingProgressBar()
        updateHeader()
    }
    
    func registerNotifications() {
        NSNotificationCenter.addObserver(self, sel: .updateHeader, name:Const.load.updateAmount)
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateHeader() {
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.averageRatingLabel.text = "Reviews Loaded : "+String(totalReviewsLoaded)
    }
    
    func addLoadingProgressBar() {
        if let bar = self.loadingProgressBar {
            bar.removeFromSuperview()
            self.loadingProgressBar = nil
        }
        self.loadingProgressBar = LoadingProgressBar()
        if let bar = self.loadingProgressBar {
            bar.createBar()
            self.addSubview(bar)
        }
    }
    
    deinit {
        if let bar = self.loadingProgressBar {
            bar.cleanup()
            bar.removeFromSuperview()
            self.loadingProgressBar = nil
        }
        unregisterNotifications()
    }
}