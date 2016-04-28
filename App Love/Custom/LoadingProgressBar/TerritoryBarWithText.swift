//
//  TerritoryBarWithText.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-06.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Subclass of TerritoryBar that adds text and review counts.
//

import UIKit

class TerritoryBarWithText: TerritoryBar {
    
    let countLabel = UILabel(frame: CGRectMake(0, 38, 20, 10))
    let territoryLabel = UILabel(frame: CGRectMake(0, 29, 20, 10))
    let borderWidthOfMiniBar:CGFloat = 0.2

    override func restoreState(loadState:LoadState) {
        super.restoreState(loadState)
        addReviewsCount(loadState.count)
        addCountryCode(loadState.territory)
        backgroundBar.borderColor = UIColor.grayColor().CGColor
        backgroundBar.borderWidth = borderWidthOfMiniBar;
    }
    
    override func updateProgress(loadState:LoadState) {
        super.updateProgress(loadState)
        addReviewsCount(loadState.count)
        backgroundBar.borderColor = UIColor.grayColor().CGColor
        backgroundBar.borderWidth = borderWidthOfMiniBar;
    }
    
    func addReviewsCount(count:Int) {
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.font = countLabel.font.fontWithSize(8)
        countLabel.textColor = .blackColor()
        countLabel.text = String(count)
        self.addSubview(countLabel)
    }

    func addCountryCode(code:String) {
        territoryLabel.textAlignment = NSTextAlignment.Center
        territoryLabel.font = territoryLabel.font.fontWithSize(10)
        territoryLabel.textColor = .blackColor()
        territoryLabel.text = String(code)
        self.addSubview(territoryLabel)
    }
}