//
//  TerritoryBar.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-07.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Represents 1 territory mini bar on the LoadingProgressBar.
//  backgroundBar CALayer is light gray, green when loading, red when error.
//  reviewCountBar: blue means (1-49 reviews loaded), black means 50-500 loaded.
//

import UIKit

class TerritoryBar: UIView {
    
    var territoryCode:String?
    var backgroundBar = CALayer()
    var reviewCountBar = CALayer()
    var width:Int = 0
    var maxBarHeight = 0
    var hasStarted = false
    var lightGrayBack = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
    var verticalAnimationDistance:CGFloat = 4.0
    
    init(territoryCode:String, width:CGFloat, height:Int) {
        super.init(frame: CGRect.zero)
        self.width = Int(width)
        self.maxBarHeight = height
        self.territoryCode = territoryCode
        
        backgroundBar.frame = CGRect(x: 0,y: 0,width: Int(width),height: maxBarHeight)
        backgroundBar.backgroundColor = lightGrayBack
        backgroundBar.cornerRadius = 3
        backgroundBar.opacity = 0.5
        self.layer.addSublayer(backgroundBar)
        
        reviewCountBar.frame = CGRect(x: 5,y: 0,width: width,height: 1)
        reviewCountBar.backgroundColor = UIColor.blueColor().CGColor
        reviewCountBar.cornerRadius = 3
        self.layer.addSublayer(reviewCountBar)
        reviewCountBar.opacity = 0.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayLoadAmount(loadState:LoadState) {
        if loadState.count < 50 {
            showFewReviewsViaBlueBar(loadState.count)
        }
        else {
            showManyReviewsViaBlackBar(loadState.count)
        }
    }
  
    func restoreState(loadState:LoadState) {
        displayLoadAmount(loadState)
        if loadState.error {
            backgroundBar.backgroundColor = UIColor.redColor().CGColor
        }
    }
    
    func showFewReviewsViaBlueBar(reviews:Int) {
        let height = maxBarHeight * reviews/50
        reviewCountBar.backgroundColor = UIColor.blueColor().CGColor
        updateReviewCountBar(reviews, width: width, height: height)
    }
    
    func showManyReviewsViaBlackBar(reviews:Int) {
        let height = maxBarHeight * reviews/500
        reviewCountBar.backgroundColor = UIColor.blackColor().CGColor
        updateReviewCountBar(reviews, width: width, height: height)
    }
    
    func updateReviewCountBar(reviews:Int, width:Int, height:Int) {
        var barHeight = height
        if barHeight > maxBarHeight { barHeight = maxBarHeight }
        if reviews > 0 {
            reviewCountBar.opacity = 1.0
            if reviews < 4 && reviews > 0 { // ensure minimum bar height is visible.
                barHeight = 2
            }
        }
        reviewCountBar.frame = CGRect(x: 0,y: maxBarHeight,width: width,height: -barHeight)
    }
    
    func showError() {
        backgroundBar.backgroundColor = UIColor.redColor().CGColor
    }
    
    func updateProgress(loadState:LoadState) {
        activeLoadingStart()
        displayLoadAmount(loadState)
        loadState.error = false
        backgroundBar.backgroundColor = UIColor.greenColor().CGColor
    }
    
    func activeLoadingStart() {
        guard hasStarted == false else { return }

        backgroundBar.backgroundColor = UIColor.greenColor().CGColor
        reviewCountBar.frame = CGRect(x: 0,y: maxBarHeight,width: width,height: 0)
        self.hasStarted = true
        
        let pos = self.center
        UIView.animateWithDuration(0.3, animations: { () -> Void in // shift down
            self.center = CGPoint(x:pos.x,y: pos.y + self.verticalAnimationDistance)
        })
    }
    
    func finishedLoading(loadState:LoadState) {
        if loadState.error {
            backgroundBar.backgroundColor = UIColor.redColor().CGColor
        }
        else {
            backgroundBar.backgroundColor = lightGrayBack
        }
        
        let pos = self.center
        if self.hasStarted == true {
            UIView.animateWithDuration(0.3, animations: { () -> Void in // shift up
                self.center = CGPoint(x:pos.x,y: pos.y - self.verticalAnimationDistance)
            })
        }
    }
}
