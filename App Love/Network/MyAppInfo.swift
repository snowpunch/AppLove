//
//  MyAppInfo.swift
//  App Love
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//

import Alamofire

class MyAppInfo {
    
    class func getInit(url:String, completion: (model:NSMutableArray?,succeeded: Bool, error:NSError?) -> Void) {
        let url = url;
        
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
                
            case .Success(let data):

                let rootDic = data as! NSDictionary
                if let resultsArray = rootDic["data"] as? [AnyObject]
                     {
//                    let appStoreModel = MyAppModel(resultsDic:finalDic)
                        let array:NSMutableArray = NSMutableArray(array: resultsArray)
                        
                    completion(model: array, succeeded: true , error: nil)
                }
                
            case .Failure(let error):
                completion(model: nil, succeeded: false , error: error)
            }
        }
    }
}