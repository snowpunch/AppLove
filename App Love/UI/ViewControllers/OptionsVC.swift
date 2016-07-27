//
//  OptionsVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-06-10.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

class OptionsVC: UIViewController, ElasticMenuTransitionDelegate {

    var contentLength:CGFloat = 180
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = false
    var dismissByForegroundDrag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Theme.lightestDefaultColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
