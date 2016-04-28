//
//  HelpAnimation.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import SpriteKit
import SwiftyGlyphs

class HelpAnimation {
    
    func startAnimation(glyphSprites:SpriteGlyphs, viewWidth:CGFloat) {
        let sprites = glyphSprites.getSprites()
        let rotate = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 1)
        rotate.timingFunction = Timing.circularEaseInOut
        let scaleUp = SKAction.scaleTo(1.0,  duration: 0.9)
        scaleUp.timingFunction = Timing.circularEaseInOut
        
        glyphSprites.centerTextToView()
        glyphSprites.getWidthOfText()
        
        var wait:Double = 0
        for glyph in sprites {
            glyph.setScale(0.0)
            glyph.position = CGPoint(x: viewWidth/2,y: 50)
            wait += 0.03
            let delay = SKAction.waitForDuration(wait)
            let pos = glyph.userData?["homeX"] as! CGFloat
            let move = SKAction.moveTo(CGPoint(x: pos,y: 25),duration: 0.8)
            move.timingFunction = Timing.circularEaseInOut
            let group = SKAction.group([rotate,move,scaleUp])
            let seq = SKAction.sequence([delay, group])
            
            glyph.runAction(seq) {
                if glyph == sprites.last {
                    self.wavingExclamationAnimation(glyph)
                }
            }
        }
    }
    
    private func wavingExclamationAnimation(exclamation:SKSpriteNode) {
        let rotateRight = SKAction.rotateToAngle(CGFloat(-M_PI/12), duration: 0.5)
        rotateRight.timingFunction = Timing.snappyEaseOut
        let rotateLeft = SKAction.rotateToAngle(CGFloat(M_PI/12), duration: 0.5)
        rotateLeft.timingFunction = Timing.snappyEaseOut
        let rotateReset = SKAction.rotateToAngle(0, duration: 0.0)
        let wave = SKAction.repeatActionForever(SKAction.sequence([rotateLeft,rotateRight]))
        
        exclamation.runAction(rotateReset) {
            exclamation.position.y = exclamation.position.y - 8
            exclamation.anchorPoint = CGPoint(x: 0.5,y: 0.2)
            exclamation.runAction(wave)
        }
    }
}