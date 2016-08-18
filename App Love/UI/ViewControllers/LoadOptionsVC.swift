//
//  LoadOptionsVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-25.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

class LoadOptionsVC: UIViewController, ElasticMenuTransitionDelegate {

    var contentLength:CGFloat = 180
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = false
    var dismissByForegroundDrag = false
    
    @IBOutlet weak var loadVersionSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = Theme.lightestDefaultColor
        initUI()
    }
    
    func initUI() {
        slider.maximumValue = 10
        slider.minimumValue = 1
        loadVersionSwitch.on = Defaults.getLoadAllBool()
        slider.value = Float(Defaults.getMaxPagesToLoadInt())
        onSliderChanged(slider)
        onSwitchChanged(loadVersionSwitch)
    }
    
    @IBAction func onSwitchChanged(button: UISwitch) {
        if button.on {
            switchLabel.text = "Load All Versions"
        }
        else {
            switchLabel.text = "Load only the latest Version"
        }
        Defaults.setLoadAll(button.on)
    }
    
    @IBAction func onSliderChanged(slider: UISlider) {
        let sliderIntValue = Int(round(slider.value))
        sliderLabel.text = "Load up to \(sliderIntValue*50) Reviews per territory"
    }
    
    @IBAction func onSliderTouchUpInside(sender: UISlider) {
        snapSaveSlider(slider)
    }
    
    @IBAction func onSliderTouchUpOutside(slider: UISlider) {
        snapSaveSlider(slider)
    }
    
    func snapSaveSlider(slider:UISlider) {
        let sliderIntValue = Int(round(slider.value))
        let snapValue = Float(sliderIntValue)
        slider.value = snapValue
        Defaults.setMaxPagesToLoad(sliderIntValue)
    }
}
