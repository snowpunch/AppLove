//
//  AppList.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-02.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Singleton that maintains persistant list of apps for the main page.
//  Also the currently selected app.
// 

import Foundation

class AppList {
    static let sharedInst = AppList()
    private init() {} // enforce singleton
    
    var appModels = [AppModel]()
    var selectedModel:AppModel?
    
    func addAppModel(model:AppModel) {
        appModels.append(model)
    }
    
    func setSelectedModel(model:AppModel?) {
        selectedModel = model
    }
    
    func getSelectedModel() -> AppModel? {
        return selectedModel
    }
    
    func getFilePath() -> String? {
        if let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first,
            let pathWithFileName = documentsDirectory.URLByAppendingPathComponent("appListFile").path {
                return pathWithFileName
        }
        return nil
    }
    
    func save() {
        if let pathWithFileName = getFilePath() {
            NSKeyedArchiver.archiveRootObject(self.appModels, toFile: pathWithFileName)
        }
    }
    
    func load() -> Bool {
        if let pathWithFileName = getFilePath(),
            let models = NSKeyedUnarchiver.unarchiveObjectWithFile(pathWithFileName) as? [AppModel] {
            self.appModels = models
            return true
        }
        return false
    }
}
