//
//  ReviewListVC+EmailReview.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import MessageUI

extension ReviewListVC: MFMailComposeViewControllerDelegate {
    
    func displayReviewEmail(model:ReviewModel) {
        if MFMailComposeViewController.canSendMail() {
            let reviewMailComposerVC = ReviewEmail.generateSingleReviewEmail(model)
            reviewMailComposerVC.mailComposeDelegate = self
            Theme.mailBar(reviewMailComposerVC.navigationBar)
            self.presentViewController(reviewMailComposerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}