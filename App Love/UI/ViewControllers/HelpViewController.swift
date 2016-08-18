//
//  HelpViewController.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-28.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Help info (includes number of territories selected).
// 

import UIKit
import SpriteKit
import SwiftyGlyphs

class HelpViewController: ElasticModalViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var skview: SKView!
    var glyphSprites:SpriteGlyphs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateHelpText()
    }

    func populateHelpText() {
        let territoriesSelected = TerritoryMgr.sharedInst.getSelectedCountryCodes().count
        let allTerritories = TerritoryMgr.sharedInst.getTerritoryCount()

        let helpText = "TIPS:\n\nCurrently there are \(territoriesSelected) territories selected out of a possible \(allTerritories).\n\nWhen selecting territories manually, the ALL button toggles between ALL and CLEAR.\n\nAfter viewing a translation, return back to this app by tapping the top left corner.\n"

        textView.backgroundColor = .clearColor()
        textView.text = helpText
        textView.userInteractionEnabled = false
        textView.selectable = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showAnimatedText()
    }
    
    func fixCutOffTextAfterRotation() {
        textView.scrollEnabled = false
        textView.scrollEnabled = true
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        fixCutOffTextAfterRotation()
    }
    
    func showAnimatedText() {
        if glyphSprites == nil {
            glyphSprites = SpriteGlyphs(fontName: "HelveticaNeue-Light", size:24)
        }
        
        if let glyphs = glyphSprites {
            glyphs.text = "At Your Service!"
            glyphs.setLocation(skview, pos: CGPoint(x:0,y:20))
            glyphs.centerTextToView()
            HelpAnimation().startAnimation(glyphs, viewWidth:skview.frame.width)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
