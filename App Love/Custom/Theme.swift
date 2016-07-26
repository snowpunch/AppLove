//
//  Theme.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-02-27.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Theme colors for the app.
//
//  cleaned

import UIKit

internal struct Theme {
    
    // dark pastel blue
    static let defaultColor = UIColor(red: 43/255, green: 85/255, blue: 127/255, alpha: 1.0)
    static let lighterDefaultColor = UIColor(red: 73/255, green: 115/255, blue: 157/255, alpha: 1.0)
    static let lightestDefaultColor = UIColor(red: 103/255, green: 145/255, blue: 197/255, alpha: 1.0)

    static func navigationBar() {
        let bar = UINavigationBar.appearance()
        bar.tintColor = .whiteColor()
        bar.barTintColor = Theme.defaultColor
        bar.translucent = false
        bar.barStyle = .Black
    }

    static func toolBar(item:UIToolbar) {
        item.tintColor = .whiteColor()
        item.barTintColor = Theme.defaultColor
        item.translucent = false
    }
    
    static func alertController(item:UIAlertController) {
        item.view.tintColor = Theme.lighterDefaultColor
    }
    
    static func searchBar(item:UISearchBar) {
        item.barTintColor = Theme.defaultColor
        item.backgroundImage = UIImage()
        item.backgroundColor = Theme.defaultColor
    }
}