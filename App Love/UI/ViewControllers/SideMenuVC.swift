//
//  SideMenuVC
//  App Love
//
//  Created by Woodie Dovich on 2016-06-08.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

private extension Selector {
    static let onMenuClose = #selector(SideMenuVC.onMenuClose)
}

class SideMenuVC: UIViewController {
    
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
    
    func sideMenuButtonPressed(notificationStrConst:String) {
        self.dismissViewControllerAnimated(true) {
            NSNotificationCenter.post(notificationStrConst)
        }
    }

    @IBAction func onTerritoryOptions(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.territories)
    }
    
    @IBAction func onLoadOptions(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.loadOptions)
    }
    
    @IBAction func onShareAppList(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.share)
    }
    
    @IBAction func onAddAppReview(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.askReview)
    }
    
    @IBAction func onHelp(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.help)
    }
    
    @IBAction func onAbout(sender: AnyObject) {
        sideMenuButtonPressed(Const.sideMenu.about)
    }
}

extension SideMenuVC: ElasticMenuTransitionDelegate {
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.post(Const.sideMenu.closeMenu) // makes menu button morph back from arrow
    }
}