//
//  AboutAnimation.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-23.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
import SwiftyGlyphs
import SpriteKit

class AboutAnimation {
    
    func startAnimation(glyphSprites:SpriteGlyphs) {
        let sprites = glyphSprites.getSprites()
        let rotateRight = SKAction.rotateToAngle(CGFloat(-M_PI/12), duration: 0.8)
        let rotateLeft = SKAction.rotateToAngle(CGFloat(M_PI/12), duration:0.8)
        let rotateBackUp = SKAction.rotateToAngle(0, duration:0.2)
        let growUp = SKAction.scaleYTo(1.5, duration: 2)
        let growDown = SKAction.scaleYTo(1.0, duration: 2)
        let moveRight = SKAction.moveByX(20, y: 0, duration: 1)
        let moveLeft = SKAction.moveByX(-20, y: 0, duration: 0.6)
        
        rotateRight.timingFunction = Timing.snappyEaseOut
        rotateLeft.timingFunction = Timing.snappyEaseOut
        growUp.timingFunction = Timing.elasticEaseOut
        growDown.timingFunction = Timing.elasticEaseOut
        moveRight.timingFunction = Timing.snappyEaseOut
        moveLeft.timingFunction = Timing.snappyEaseOut
        
        // random 'withRange' provides a bit of glyph individuality.
        let wait = SKAction.waitForDuration(0.05, withRange: 0.1)
        
        let shimmySequence = SKAction.sequence([moveRight,moveLeft,rotateBackUp])
        let growthSequence = SKAction.sequence([growUp,growDown,wait,growUp,growDown,wait])
        let swaySequence = SKAction.sequence([rotateLeft,wait,rotateRight])
        
        let group = SKAction.group([growthSequence,swaySequence,shimmySequence])
        let repeatAction = SKAction.repeatActionForever(group)
        
        for glyph in sprites {
            glyph.anchorPoint = CGPoint(x:0.5, y:0.2)
            glyph.runAction(repeatAction)
        }
    }
}
