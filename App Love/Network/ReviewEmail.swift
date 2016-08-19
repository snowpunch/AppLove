//
//  ReviewEmail.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-28.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Generate email for a single review.

import UIKit
import MessageUI

class ReviewEmail: NSObject {

    class func getReviewMessageBody(reviewModel:ReviewModel) -> String {
        let title = reviewModel.title ?? ""
        let comment = reviewModel.comment ?? ""
        let rating = reviewModel.rating ?? ""
        let version = reviewModel.version ?? ""
        let name =  reviewModel.name ?? ""
        let territory =  reviewModel.territory ?? ""

        var msgBody = "<small>\(rating) stars - (\(version))<br></small>"
        msgBody += "<small><b>\(title)</b><br></small>"
        msgBody += "<small>\(comment)</small><br>"
        msgBody += "<small><b>(\(territory)) - \(name)</b><br></small>"
        
        return msgBody
    }
    
    
    class func generateSingleReviewEmail(reviewModel:ReviewModel) -> MFMailComposeViewController {
        
        let appModel = AppList.sharedInst.getSelectedModel()
        var appName = appModel?.appName ?? ""
        appName = appName.truncate(30)
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setSubject("\(appName) Review")
        var msgBody = ReviewEmail.getReviewMessageBody(reviewModel)
        
        let appLovePlug = "<small><br><a href='https://itunes.apple.com/app/id\(Const.appId.AppLove)'>App Love</a></small>"
        msgBody += appLovePlug
        
        mailComposerVC.setMessageBody(msgBody, isHTML: true)
        return mailComposerVC
    }
}