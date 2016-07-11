//
//  OptionsVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-06-10.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import ElasticTransition

class OptionsVC: UIViewController,ElasticMenuTransitionDelegate {

    var contentLength:CGFloat = 300
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = false
    var dismissByForegroundDrag = false
    
    //var optionSwitch:SevenSwitch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //optionSwitch = createSwitch("TERRITORY",position: CGPoint(x:80,y:290),
        //             action: #selector(SideMenuViewController.switchChanged))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createSwitch(text:String,position:CGPoint,action:Selector) -> SevenSwitch {
        let size = CGSize (width: 140, height: 40)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        let textSwitch = SevenSwitch(frame: frame)
        textSwitch.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 + 150)
        textSwitch.addTarget(self, action: action, forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(textSwitch)
        textSwitch.center = position
        
        // Customizations
        textSwitch.knobText = text
        //textSwitch.onTextColor = UIColor(red: 52/255.0, green: 224/255.0, blue: 155/255.0, alpha: 1)
        //textSwitch.offTextColor = UIColor(red: 176/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1)
        textSwitch.onTextColor = UIColor(red: 52/255.0, green: 100/255.0, blue: 52/255.0, alpha: 1)
        textSwitch.offTextColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 1)
        
        textSwitch.onTintColor = UIColor(red: 88/255.0, green: 211/255.0, blue: 88/255.0, alpha: 1)
        textSwitch.knobMargin = 4.0
        textSwitch.backgroundView.layer.borderWidth = 1.0
        
        return textSwitch
    }
    
    func switchChanged(sender: SevenSwitch) {
        print("Changed value to: \(sender.on)")
    }

}
