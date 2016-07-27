//
//  TranslationOptionsVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

class TranslationOptionsVC: UIViewController, ElasticMenuTransitionDelegate {

    var contentLength:CGFloat = 180
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = false
    var dismissByForegroundDrag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    func initUI() {
//        slider.maximumValue = 10
//        slider.minimumValue = 1
//        loadVersionSwitch.on = Defaults.getLoadAllBool()
//        slider.value = Float(Defaults.getMaxPagesToLoadInt())
//        onSliderChanged(slider)
    }

}
