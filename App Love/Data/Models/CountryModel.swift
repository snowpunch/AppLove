//
//  CountryModel.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Main purpose if to store which territories are selected.
//  Also the full name of the territory.
//

import UIKit

class CountryModel: NSObject {

    var code:String?
    var country:String?
    var isSelected:Bool
    
    init(code:String, country:String) {
        self.code = code
        self.country = country
        self.isSelected = false
    }
}