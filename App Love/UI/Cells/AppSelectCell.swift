//
//  AppSelectCell.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-27.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Search results showing various apps with a 'UISwitch'
// 

import UIKit

class AppSelectCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    weak var appModel:AppModel?
    
    func setup(model:AppModel) {
        if let urlStr = model.icon100,
            let url =  NSURL(string:urlStr) {
                iconImage.sd_setImageWithURL(url, placeholderImage: UIImage(named:"defaulticon"))
        }
        
        appModel = model
        
        // changes here are in flux as Apple decides what is ok.
        appName.text = "Get Reviews"
        ratingsCountLabel.text = model.appName
        
        if SearchList.sharedInst.hasItem(model) {
            self.addSwitch.setOn(true, animated: false)
        }
        else {
            self.addSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func onSwitchPressed(control: UISwitch) {
        if let model = self.appModel {
            if control.on {
                SearchList.sharedInst.addAppModel(model)
            }
            else {
                SearchList.sharedInst.removeAppModel(model)
            }
        }
    }
}
