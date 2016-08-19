//
//  GlobalSplitVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-06-11.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit

class GlobalSplitVC: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }
    
    func splitView(splitView: UISplitViewController, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
            return true
    }
    
    override func awakeFromNib() {
        self.delegate = self;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
