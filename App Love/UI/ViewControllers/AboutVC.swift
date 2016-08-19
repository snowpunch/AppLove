//
//  AboutVC.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-01.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  About with version number.
// 

import UIKit
import SpriteKit
import SwiftyGlyphs
import ElasticTransition

class AboutVC: ElasticModalViewController {

    @IBOutlet weak var skview: SKView!
    @IBOutlet weak var textView: UITextView!
    var glyphSprites:SpriteGlyphs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getVersion() -> String? {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }

    func populateText() {
        let aboutText = "\nDepending upon time available and how well this app is received some possible upcoming features could include:\n\n - Saving all reviews into Core Data to capture territories that pass the 500 threshold.\n- Highlighting new reviews upon re-loading.\n\nFull source code on Github.\n\nCheers,\nWoodie Dovich\n\n"
        
        textView.backgroundColor = .clearColor()
        textView.text = aboutText
        textView.userInteractionEnabled = false
        textView.selectable = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateText()
        showAnimatedVersion()
    }
 
    func showAnimatedVersion() {
        guard let version = getVersion() else { return }
        if glyphSprites == nil {
            glyphSprites = SpriteGlyphs(fontName: "HelveticaNeue-Light", size:24)
        }
        
        if let glyphs = glyphSprites {
            glyphs.text = "Version "+version
            glyphs.setLocation(skview, pos: CGPoint(x:0,y:30))
            glyphs.centerTextToView()
            AboutAnimation().startAnimation(glyphs)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
