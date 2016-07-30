//
//  ReviewModel.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-14.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  A single persons review about an app.
//  Compatible with both JSON and XML.
//

import UIKit
import SwiftyJSON

class ReviewModel {

    var title:String?
    var comment:String?
    var rating:String?
    var version:String?
    var name:String?
    var territory:String?
    var territoryCode:String?
    var date = NSDate()
    var flag:Bool = false
    var reviewID:String = ""
    
    init(json:JSON) {
        self.title = json["title"]["label"].string
        self.comment = json["content"]["label"].string
        self.rating = json["im:rating"]["label"].string
        self.version = json["im:version"]["label"].string
        self.name = json["author"]["name"]["label"].string
        setId()
    }

    init(xml:XMLIndexer) {
        self.title = xml["title"].element?.text
        self.comment = xml["content"][0].element?.text
        self.rating = xml["im:rating"].element?.text
        self.version = xml["im:version"].element?.text
        self.name = xml["author"]["name"].element?.text
        setId()
    }
    
    func setId() {
        if let userName = self.name, userTitle = self.title {
             self.reviewID = userName + "-" + userTitle
        }
    }
}
