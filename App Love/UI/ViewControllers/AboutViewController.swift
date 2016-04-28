//
//  AboutViewController.swift
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

class AboutViewController: UIViewController {

    @IBOutlet weak var skview: SKView!
    @IBOutlet weak var textView: UITextView!
    lazy var glyphSprites = SpriteGlyphs(fontName: "HelveticaNeue-Light", size:24)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        populateText()
    }

    func getVersion() -> String? {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }

    func populateText() {
        let aboutText = "We all want people to love our apps. However, just your own country's reviews are often just not enough.\n\nThis app lets you see ALL reviews for any iOS app. That is, you can view every territory at once or you can custom select which territories to download reviews from.\n\nYou can also translate languages and sort the reviews.\n\nFacebook alone has many thousands of reviews. But there are server limits to how many reviews that you can download. The server resets after some time so prioritize what apps that you want to check out.\n\nCheers,\nWoodie Dovich\n\n"
        
        textView.backgroundColor = .clearColor()
        textView.text = aboutText
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimatedVersion()
    }
 
    func showAnimatedVersion() {
        guard let version = getVersion() else { return }
        
        glyphSprites.text = "Version "+version
        glyphSprites.setLocation(skview, pos: CGPoint(x:0,y:30))
        glyphSprites.centerTextToView()
        AboutAnimation().startAnimation(glyphSprites)
    }
}
