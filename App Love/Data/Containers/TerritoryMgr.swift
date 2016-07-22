//
//  TerritoryMgr.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Keeps track of territories selected and the full names of territories.
// 

import UIKit

class TerritoryMgr: NSObject {

    static let sharedInst = TerritoryMgr()
    
    private var modelDictionary = [String:CountryModel]()
    
    private var defaultTerritories = [String]()
    
    private override init() { // enforce singleton
        super.init()
        createModelDictionary()
        setDefaultCountries()
    }
    
    func createModelDictionary() {
        let dictionary = TerritoryList.getDictionary()
        for (code, country) in dictionary {
            modelDictionary[code] = CountryModel(code: code,country: country)
        }
    }
    
    func getTerritoryCount() -> Int {
        return modelDictionary.count
    }

    func setDefaultCountries() {
        let defaultCodes = getDefaultCountryCodes()
        for code in defaultCodes {
            modelDictionary[code]?.isSelected = true
        }
    }
    
    func setSelectedTerritories(selectedTerritories:[String]) {
        
        for model in self.modelDictionary.values {
            model.isSelected = false
        }
        for code in selectedTerritories {
            modelDictionary[code]?.isSelected = true
        }
    }
    
    // for table
    func getArrayOfModels() -> [CountryModel] {
        var array = Array(modelDictionary.values)
        array.sortInPlace({ $0.country < $1.country })
        return array
    }
    
    // for network operations
    func getSelectedCountryCodes() -> [String] {
        var selectedCodes = [String]()
        for model in self.modelDictionary.values {
            if model.isSelected, let code = model.code {
                selectedCodes.append(code)
            }
        }
        return selectedCodes
    }
    
    func setSelected(code:String, selected:Bool) {
        modelDictionary[code]?.isSelected = selected
    }
    
    // update user territory preferences
    func updateFromTableState(tableState:[CountryModel]) {
        for model in tableState {
            if let code = model.code {
                if let localModel = self.modelDictionary[code] {
                    localModel.isSelected = model.isSelected
                }
            }
        }
    }
    
    func getTerritory(code:String) -> String? {
        if let country = modelDictionary[code]?.country {
            return country
        }
        return nil
    }
}

// default territories
extension TerritoryMgr {
    
    func getOriginalDefaults() -> [String] {
        defaultTerritories = ["US","JP","GB","DE","AU","CA","IE","AT","CN","SG","IT","HR","RU","GR","PT"];
        return defaultTerritories
    }
    
    func selectAllTerritories() {
        for model in self.modelDictionary.values {
            model.isSelected = true
        }
    }
    
    func setOriginalDefaults() {
        let defaultCodes = getOriginalDefaults()
        for code in defaultCodes {
            modelDictionary[code]?.isSelected = true
        }
    }
    
    // Default 15 app store selected (out of possible 155)
    func getDefaultCountryCodes() -> [String] {
        if (load() == false) {
            defaultTerritories = getOriginalDefaults()
        }
        save()
        return defaultTerritories
    }
    
    func getFilePath() -> String? {
        if let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first,
            let pathWithFileName = documentsDirectory.URLByAppendingPathComponent("defaultTerritories").path {
            return pathWithFileName
        }
        return nil
    }
    
    func save() {
        if let pathWithFileName = getFilePath() {
            NSKeyedArchiver.archiveRootObject(defaultTerritories, toFile: pathWithFileName)
        }
    }
    
    func saveSelectedAsDefault() {
        defaultTerritories = getSelectedCountryCodes()
        save()
    }
    
    func load() -> Bool {
        if let pathWithFileName = getFilePath(),
            let loadedDefaults = NSKeyedUnarchiver.unarchiveObjectWithFile(pathWithFileName) as? [String] {
            defaultTerritories = loadedDefaults
            return true
        }
        return false
    }
}
