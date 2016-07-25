//
//  SearchApps.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads array of suggested [AppModel] for search terms.
// 

import Alamofire
import SwiftyJSON

class SearchApps {
    
    class func get(searchStr:String, completion: (appsFound:[AppModel]?,succeeded: Bool, error:NSError?) -> Void) {
        let array = searchStr.characters.split {$0 == " "}.map(String.init)
        
        let searchTermsStr = array.joinWithSeparator("+").lowercaseString
        print("array:\(array),\(searchTermsStr),\(searchStr)")
        let url = "https://itunes.apple.com/search?term=\(searchTermsStr)&entity=software"
        
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success(let data):
                var apps = [AppModel]()
                if let resultsArray = data["results"] as? [AnyObject] {
                    for resultsDic in resultsArray {
                        let app = AppModel(resultsDic: resultsDic as! [String : AnyObject])
                        apps.append(app)
                    }
                }
                completion(appsFound: apps, succeeded: true , error: nil)
                
            case .Failure(let error):
                completion(appsFound: nil, succeeded: false , error: error)
            }
        }
    }
}
