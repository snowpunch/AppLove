//
//  SearchList.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-02.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Singleton that collects selected Apps from search results.
//  Transfered to persistant AppList when leaving AppSearchViewController.
//  Allows for multiple searches without leaving the page.
//  

import Foundation

class SearchList {
    static let sharedInst = SearchList()
    private init() {} // enforce singleton
    
    var appModelDic = [Int:AppModel]()
    
    func addAppModel(model:AppModel) {
        appModelDic[model.appId] = model
    }
    
    func removeAppModel(model:AppModel) {
       appModelDic[model.appId] = nil
    }
    
    func getArray() -> [AppModel] {
        return Array(appModelDic.values)
    }
    
    func removeAll() {
        appModelDic.removeAll()
    }
    
    func hasItem(model:AppModel) -> Bool {
        if let _ = appModelDic[model.appId] {
            return true
        }
        return false
    }
}