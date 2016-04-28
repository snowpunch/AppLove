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

class HelpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
   
    @IBOutlet weak var skview: SKView!
    lazy var glyphSprites = SpriteGlyphs(fontName: "MarkerFelt-Wide", size:24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateHelpText()
    }

    func populateHelpText() {
        let territoriesSelected = TerritoryMgr.sharedInst.getSelectedCountryCodes().count
        let allTerritories = TerritoryMgr.sharedInst.getTerritoryCount()

        let helpText = "Territory Selector:\n\nYou can pick and choose which territories to load. Just a few or all \(allTerritories) territories. Currently there are \(territoriesSelected) territories selected. Up to 500 reviews can be loaded from each territory.\n\nTranslations:\n\nAfter viewing a translation, return back to app by tapping the top left corner. Google's translation service can translate to and from any language.\n\nLoading Indicator:\n\nEach piece of the loading bar represents a territory. Red represents a loading error. Blue represents (1-50) loaded reviews. Black represents 51-500 reviews. Green background means currently loading.\n\nLandscape:\n\nRotate device sideways for landscape view.\n\nCache:\n\nPull down to refresh to re-download from scratch and ignore the cache."

        textView.backgroundColor = .clearColor()
        textView.text = helpText
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimatedText()
    }
    
    func showAnimatedText() {
        glyphSprites.text = "At Your Service!"
        glyphSprites.setLocation(skview, pos: CGPoint(x:0,y:20))
        glyphSprites.centerTextToView()

        HelpAnimation().startAnimation(glyphSprites, viewWidth:skview.frame.width)
    }
}
