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
        
        //initVersionsToggleSwitch()
        initSlider()
        
        // restore
        let defaults = NSUserDefaults.standardUserDefaults()
        loadVersionSwitch.on = defaults.boolForKey(Const.defaults.loadAllVersionsKey)
        slider.value = Float(defaults.integerForKey(Const.defaults.maxPagesToLoadKey))
        onSliderChanged(slider)
    }
    
    func initSlider() {
        slider.maximumValue = 10
        slider.minimumValue = 1
        slider.continuous = true
    }
    
    func initVersionsToggleSwitch() {
        let defaults = NSUserDefaults.standardUserDefaults()
        loadVersionSwitch.on = defaults.boolForKey(Const.defaults.loadAllVersionsKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSwitchChanged(button: UISwitch) {
        if button.on {
            switchLabel.text = "Load All Versions"
        }
        else {
            switchLabel.text = "Load only the latest Version"
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(button.on, forKey: Const.defaults.loadAllVersionsKey)
    }
    
    @IBAction func onSliderChanged(slider: UISlider) {
        let sliderIntValue = Int(round(slider.value))
        sliderLabel.text = "Load up to \(sliderIntValue*50) Reviews per territory"
    }
    
    @IBAction func onSliderTouchUpInside(sender: UISlider) {
        snapSave(slider)
    }
    
    @IBAction func onSliderTouchUpOutside(slider: UISlider) {
        snapSave(slider)
    }
    
    func snapSave(slider:UISlider) {
        let sliderIntValue = Int(round(slider.value))
        let snapValue = Float(sliderIntValue)
        slider.value = snapValue
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(sliderIntValue, forKey: Const.defaults.maxPagesToLoadKey)
    }
}
