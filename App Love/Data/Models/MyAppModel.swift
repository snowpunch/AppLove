//
//  MyAppModel.swift
//  App Love
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//
import UIKit
import SwiftyJSON

class MyAppModel: NSObject,NSCoding {
    var title:String?
    var developer:String?
    var icon:String?
    var price:String?
    var size:String?
    var appId:Int = 0
    
    init(resultsDic:NSDictionary) {
        self.title = resultsDic.objectForKey("title")as? String
        self.developer = resultsDic.objectForKey("developer") as? String
        self.icon = resultsDic.objectForKey("icon") as? String
        self.price = resultsDic.objectForKey("price") as? String
        self.size = resultsDic.objectForKey("size") as? String
        self.appId = resultsDic.objectForKey("appid") as? Int ?? 0
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
//        print(decoder.decodeObjectForKey("title"));
        self.title = decoder.decodeObjectForKey("title") as? String
        self.developer = decoder.decodeObjectForKey("developer") as? String
        self.icon = decoder.decodeObjectForKey("icon") as? String
        self.price = decoder.decodeObjectForKey("price") as? String
        self.size = decoder.decodeObjectForKey("size") as? String
        self.appId = decoder.decodeIntegerForKey("appId") as Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.developer, forKey: "developer")
        aCoder.encodeObject(self.icon, forKey: "icon")
        aCoder.encodeObject(self.price, forKey: "price")
        aCoder.encodeObject(self.size, forKey: "size")
        aCoder.encodeInteger(self.appId, forKey: "appId")
    }

}
