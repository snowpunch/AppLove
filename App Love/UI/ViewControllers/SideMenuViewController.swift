//
//  SideMenuViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-06-08.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(SideMenuViewController.onMenuClose)
}

class SideMenuViewController: UIViewController {
    
    // ElasticMenu props
    var contentLength:CGFloat = 160
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    var transition = ElasticTransition()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.defaultColor
    }

    func onMenuClose() {
        self.dismissViewControllerAnimated(true, completion:nil)
    }

    @IBAction func onTerritoryOptions(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.territories)
        }
    }
    
    @IBAction func onLoadOptions(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.loadOptions)
        }
    }
    
    @IBAction func onTranslateOptions(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.translateOptions)
        }
    }
    
    @IBAction func onShareAppList(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.share)
        }
    }
    
    @IBAction func onAddAppReview(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.askReview)
        }
    }
    
    @IBAction func onHelp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.help)
        }
    }
    
    @IBAction func onAbout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(Const.sideMenu.about)
        }
    }
}

extension SideMenuViewController: ElasticMenuTransitionDelegate {
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.post(Const.sideMenu.closeMenu) // makes menu button morph back from arrow
    }
}