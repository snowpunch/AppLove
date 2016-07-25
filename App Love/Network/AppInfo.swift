//
//  AppInfo.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads app info (needed to create an AppModel) from a single app id.
// 

import Alamofire

class AppInfo {

    class func get(appID:String, completion: (model:AppModel?,succeeded: Bool, error:NSError?) -> Void) {
        let url = "https://itunes.apple.com/lookup?id=\(appID)"
        
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
                
            case .Success(let data):
                let rootDic = data as! [String : AnyObject]
                if let resultsArray = rootDic["results"] as? [AnyObject],
                    let finalDic = resultsArray[0] as? [String: AnyObject] {
                        let appStoreModel = AppModel(resultsDic:finalDic)
                        completion(model: appStoreModel, succeeded: true , error: nil)
                }
                
            case .Failure(let error):
                completion(model: nil, succeeded: false , error: error)
            }
        }
        
    }
}
