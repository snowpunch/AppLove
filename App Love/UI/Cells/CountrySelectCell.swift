//
//  CountrySelectCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-12.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  UISwitch to include a territory to download.
// 

import UIKit

class CountrySelectCell: UITableViewCell {

    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    weak var model:CountryModel?
    
    func setup(model:CountryModel) {
        self.model = model
        codeLabel.text = model.code
        countryLabel.text = model.country
        
        if model.isSelected {
            self.addSwitch.setOn(true, animated: false)
        }
        else {
            self.addSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func onSwitchPressed(control: UISwitch) {
        if control.on {
            model?.isSelected = true
        }
        else {
            model?.isSelected = false
        }
    }
}
