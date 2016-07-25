//
//  LoadState.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-08.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  For progress display of a territory.
//

import UIKit

class LoadState {
    
    var territory:String
    var count:Int = 0 // current reviews loaded (0-500)
    var error:Bool = false
    
    init(territory:String) {
        self.territory = territory
    }
}
