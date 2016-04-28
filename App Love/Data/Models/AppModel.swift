//
//  AppModel.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Represents a single App. Serializable for persistance.
//

import UIKit
import SwiftyJSON

class AppModel: NSObject, NSCoding{
    
    var appName:String?
    var companyName:String?
    var icon100:String?
    var averageUserRating:Float = 0.0
    var userRatingCount:Int = 0
    var appId:Int = 0
    
    init(resultsDic:[String: AnyObject]) {
        self.appName = resultsDic["trackName"] as? String
        self.companyName = resultsDic["artistName"] as? String
        self.icon100 = resultsDic["artworkUrl100"] as? String
        self.averageUserRating = resultsDic["averageUserRating"] as? Float ?? 0.0
        self.userRatingCount = resultsDic["userRatingCount"] as? Int ?? 0
        self.appId = resultsDic["trackId"] as? Int ?? 0
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        appName = decoder.decodeObjectForKey("appName") as? String
        companyName = decoder.decodeObjectForKey("companyName") as? String
        icon100 = decoder.decodeObjectForKey("icon100") as? String
        averageUserRating = decoder.decodeFloatForKey("averageUserRating") as Float
        userRatingCount = decoder.decodeIntegerForKey("userRatingCount") as Int
        appId = decoder.decodeIntegerForKey("appId") as Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(appName, forKey: "appName")
        aCoder.encodeObject(companyName, forKey: "companyName")
        aCoder.encodeObject(icon100, forKey: "icon100")
        aCoder.encodeFloat(averageUserRating, forKey: "averageUserRating")
        aCoder.encodeInteger(userRatingCount, forKey: "userRatingCount")
        aCoder.encodeInteger(appId, forKey: "appId")
    }
}