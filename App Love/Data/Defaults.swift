//
//  Defaults.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  NSUserDefaults wrapper

import UIKit

class Defaults: NSObject {

    class func setInitialDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(Const.defaults.loadAllVersionsKey) == nil {
            defaults.setBool(false, forKey: Const.defaults.loadAllVersionsKey)
        }
        if defaults.objectForKey(Const.defaults.maxPagesToLoadKey) == nil {
            defaults.setInteger(10, forKey: Const.defaults.maxPagesToLoadKey)
        }
    }
    
    class func setLoadAll(loadAll:Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(loadAll, forKey: Const.defaults.loadAllVersionsKey)
    }
    
    class func getLoadAllBool() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(Const.defaults.loadAllVersionsKey)
    }
    
    class func setMaxPagesToLoad(maxPages:Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(maxPages, forKey: Const.defaults.maxPagesToLoadKey)
    }
    
    class func getMaxPagesToLoadInt() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(Const.defaults.maxPagesToLoadKey)
    }
}