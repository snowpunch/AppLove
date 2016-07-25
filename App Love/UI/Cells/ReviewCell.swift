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

    @IBOutlet weak var authorLabel: UILabel! 
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var translateIcon: UIImageView!
    var stars = [UIImageView]()
    
    func setup(model:ReviewModel) {
        
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
                translateIcon.hidden = false
                if isEnglishCountry(territory) {
                    translateIcon.hidden = true
                }
        }
        else {
            authorLabel.text = ""
        }
    }
    
    // todo: could be pre-calculated and added to model.
    func isEnglishCountry(territory:String) -> Bool {
        if territory == "United States" || territory == "Canada"
        || territory == "United Kingdom" || territory == "Australia" {
            return true
        }
        return false
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let quarterCellWidth = self.frame.width / 4
        let rightSideHitArea = CGRect(x: quarterCellWidth*3,y: 0,width: quarterCellWidth,height: self.frame.height)
        let touch = touches.first as UITouch!
        let touchPoint = touch.locationInView(self)

        if CGRectContainsPoint(rightSideHitArea, touchPoint) {
            displayGoogleTranslationViaSafari()
        }
    }
    
    func displayGoogleTranslationViaSafari() {
        guard let title = titleLabel.text else  { return }
        
        let rawUrlStr = "http://translate.google.ca?text="+title + "\n" + reviewLabel.text!
        if let urlEncoded = rawUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let url = NSURL(string: urlEncoded) {
                UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func removeStars() {
        for imageView in stars {
            imageView.removeFromSuperview()
        }
        stars.removeAll()
    }

    override func prepareForReuse() {
        removeStars()
    }
}