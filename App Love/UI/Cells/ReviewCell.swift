//
//  ReviewCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-23.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Displays user comments, visual stars for rating, allows translations.
// 

import UIKit
import Foundation

class ReviewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel! 
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var model:ReviewModel? = nil
    var stars = [UIImageView]()
    
    func setup(model:ReviewModel) {
        
        self.model = model;
        
        if let title = model.title, let comment = model.comment {
            titleLabel.text = title
            reviewLabel.text = comment
            reviewLabel.numberOfLines = 0
            reviewLabel.sizeToFit()
        }

        if let name = model.name, let rating = model.rating,
            let version = model.version, let territory = model.territory {
                let ratingNumber = Int(rating) ?? 1
                let str = "\(territory) v\(version) \(name)"
                self.authorLabel.text = str
                self.addStars(ratingNumber)
        }
        else {
            authorLabel.text = ""
        }
        
        if let territoryCode = model.territoryCode {
            flagImage.image = UIImage(named:territoryCode)
        }
    }
    
    func addStars(rating:Int) {
        var xpos:CGFloat = 13.0
        for _ in 1...rating {
             addStar(xpos)
            xpos += 13
        }
    }
    
    func layoutStars() {
        for star in stars {
            star.center = CGPoint(x: star.center.x, y: authorLabel.center.y-1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutStars()
    }
    
    func addStar(pos:CGFloat) {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"star")
        imageView.frame = CGRect(x: pos,y: authorLabel.center.y,width: 13,height: 13)
        self.addSubview(imageView)
        stars.append(imageView)
    }
    
    func removeStars() {
        for imageView in stars {
            imageView.removeFromSuperview()
        }
        stars.removeAll()
    }
    
    @IBAction func onReviewButton(button: UIButton) {
        if let modelData = self.model {
            let data:[String:AnyObject] = ["reviewModel":modelData, "button":button]
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Const.reviewOptions.showOptions, object:nil, userInfo:data)
        }
    }
    
    override func prepareForReuse() {
        removeStars()
    }
}