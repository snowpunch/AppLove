//
//  ReviewParser.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-06.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  parses both xml and json formats.
//  

import UIKit
import Alamofire
import SwiftyJSON

class ReviewParser: NSObject {
    
    var fullTerritoryName:String
    let pageInfo:PageInfo
    
    init(pageInfo:PageInfo) {
        self.pageInfo = pageInfo
        self.fullTerritoryName = TerritoryMgr.sharedInst.getTerritory(pageInfo.territory) ?? pageInfo.territory
    }
    
    func createModels(data:NSData) -> [ReviewModel] {
        if self.pageInfo.preferJSON == true {
            return createModelsFromJSON(data)
        }
        return createModelsFromXML(data)
    }
    
    func createModelsFromXML(data:NSData) -> [ReviewModel] {
        var reviewsArray = [ReviewModel]()
        let xml = SWXMLHash.parse(data)
        let reviews = xml["feed"]["entry"]
        for item in reviews {
            let review = ReviewModel(xml: item)
            if review.name != nil {
                review.territory = fullTerritoryName
                reviewsArray.append(review)
            }
        }
        return reviewsArray
    }
    
    func createModelsFromJSON(data:NSData) -> [ReviewModel] {
        var reviewsArray = [ReviewModel]()
        do {
            let jsonResults = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            let json = JSON(jsonResults)
            if let entryArray = json["feed"]["entry"].array {
                for json in entryArray {
                    let review = ReviewModel(json: json)
                    if (review.name != nil) {
                        review.territory = fullTerritoryName
                        review.territoryCode = pageInfo.territory
                        reviewsArray.append(review)
                    }
                }
            }
        } catch _ as NSError {
            print("json error")
        }
        return reviewsArray
    }
}
