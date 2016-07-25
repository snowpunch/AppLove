//
//  AppCategoryItem.swift
//  App Love
//
//  Created by Apple on 16/7/19.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//

import UIKit

class AppCategoryItem: NSObject {
    
    var title:String?
    var url:String?
    var sort:String?
    var icon:String?
    
    init(dic:NSDictionary) {
        self.title = dic.objectForKey("title") as? String
        self.url = dic.objectForKey("url") as? String
        self.sort = dic.objectForKey("sort") as? String ?? "hot"
        self.icon = dic.objectForKey("icon") as? String
    }
    

}
