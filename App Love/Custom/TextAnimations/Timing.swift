//
//  Timing.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Some common timing functions found online.
//

import Foundation

class Timing {
    
    class func elasticEaseOut (t:Float) -> Float {
        return sin(-13.0 * Float(M_PI)/2 * (t + 1.0)) * pow(2.0, -10.0 * t) + 1.0
    }
    
    class func snappyEaseOut (t:Float) -> Float {
        return (t == 1.0) ? t : 1.0 - pow(2.0, -10.0 * t)
    }
    
    class func circularEaseInOut(t:Float) -> Float {
        if t < 0.5 {
            return 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
        } else {
            return 0.5 * sqrt(-4.0 * t * t + 8.0 * t - 3.0) + 0.5
        }
    }
}