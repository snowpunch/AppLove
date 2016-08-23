//
//  AppCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Display App Icon on main page with a few labels.
// 

import UIKit
import SDWebImage

class AppCell: UITableViewCell {
    
    @IBOutlet weak var appIconImgView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var aveRatingLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    func setup(model:AppModel) {
        if let urlStr = model.icon100,
            let url =  NSURL(string:urlStr) {
                appIconImgView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"defaulticon"))
        }
        
        appNameLabel.text = "View Reviews"
        companyLabel.text = model.appName
        
        if model.averageUserRating != 0 {
             aveRatingLabel.text = "Average Rating: "+String(model.averageUserRating)
        }
        else {
            aveRatingLabel.text = "Not enough ratings yet."
        }
    }
}

