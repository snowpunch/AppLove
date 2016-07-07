//
//  PageInfo.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-11.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Common properties passed when Loading pages of a territory.
//  These properties also represent variables in the URL.
//

import UIKit

class PageInfo: NSObject {

    let territory:String
    let appId:Int
    var page = 0            // current page loading (1-10)
    var preferJSON = true   // false means use XML.
    
    init(appId:Int, territory: String) {
        self.appId = appId
        self.territory = territory
    }
}
