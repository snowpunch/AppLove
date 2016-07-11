//
//  MenuButton.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-06-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Custom MenuButton designed to complement ElasticTranistion's side
//  menu animation with the help of SwiftyGlyphs.

import UIKit
import SwiftyGlyphs

@IBDesignable
class MenuButton: UIControl {
    
    lazy var swiftyGlyphs = SwiftyGlyphs(fontName: "HelveticaNeue-Thin", size:24)
    var icon = UIImageView()
    var buttonText:String?
    
    @IBInspectable internal var image: UIImage? {
        get { return icon.image }
        set(image) { icon.image = image }
    }
    
    @IBInspectable internal var text : String? {
        didSet { buttonText = text }
    }
    
    override func didMoveToWindow() {
        initMenuItem()
        animateIcon()
        animateGlyphs()
    }
    
    func initMenuItem() {
        self.icon.sizeToFit()
        self.addSubview(self.icon)
        
        let centerY = self.frame.size.height/2
        self.icon.center = CGPoint(x:icon.center.x, y:centerY)
        swiftyGlyphs.label.textColor = UIColor.whiteColor()
        swiftyGlyphs.text = self.buttonText
        swiftyGlyphs.setLocation(self, pos: CGPoint(x:0,y:0))
        swiftyGlyphs.layout(CGPoint(x:45,y:centerY))
    }
    
    // slide+scale from left to complement other animations.
    func animateIcon() {
        let endPos = icon.center
        icon.center = CGPoint(x: endPos.x-20,y: endPos.y)
        icon.transform = CGAffineTransformMakeScale(0.5,0.5)
        UIView.animateWithDuration(0.8, delay:0.2, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5,
                                   options: [.CurveEaseOut], animations: {
                                    self.icon.transform = CGAffineTransformMakeScale(1.0,1.0)
                                    self.icon.center = endPos
        }, completion: nil)
    }
    
    // cascading move+twist with a touch of whiplash to complement menu opening animation.
    func animateGlyphs() {
    
        var cascadeDelay = 0.0
        for glyph in swiftyGlyphs.getGlyphs() {
            
            glyph.imgView.transform = CGAffineTransformMakeRotation(-2.0)
            glyph.imgView.center = CGPoint(x:glyph.position.x-50,y:glyph.position.y)

            UIView.animateWithDuration(0.8, delay:0.1+cascadeDelay, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5,
                                                   options: [.CurveEaseOut], animations: {
                    glyph.imgView.center = CGPoint(x:glyph.position.x,y:glyph.position.y)
             }, completion: { (completed) in
            })
            
            UIView.animateWithDuration(0.8, delay:0.2+cascadeDelay*2, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5,
                                       options: [.CurveEaseOut], animations: {
                                        glyph.imgView.transform = CGAffineTransformMakeRotation(0.0)
                }, completion: nil)
            cascadeDelay += 0.02
        }
    }
    
    // bounce icon big
    func doPressAnimation(completion: () -> Void) {
        icon.transform = CGAffineTransformMakeScale(0.8,0.8)
        UIView.animateWithDuration(0.5, delay:0, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5,
                                   options: [.CurveEaseOut], animations: {
                                    self.icon.transform = CGAffineTransformMakeScale(1.3,1.3)
            }, completion: { (completed) in
                completion()
        })
    }
    
    // send action after press animation
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        doPressAnimation {
           super.sendAction(action, to: target, forEvent: event)
        }
    }
}