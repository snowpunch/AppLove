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

    // Default 15 app store selected (out of possible 155)
    func getDefaultCountryCodes() -> [String] {
        return ["US","JP","GB","DE","AU","CA","IE","AT","CN","SG","IT","HR","RU","GR","PT"]
    }
    
    func setDefaultCountries() {
        let defaultCodes = getDefaultCountryCodes()
        for code in defaultCodes {
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
