//
//  Const.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-04.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Global constants.
//  

struct Const {

    // app id's
    struct appId {
        static let MusketSmoke = 436684234
        static let AppLove = 1099336831
    }
    
    // NSNotifications
    struct load {
        static let updateAmount = "updateAmount"
        static let dataError = "dataError"
        static let territoryDone = "territoryDone"
        static let territoryStart = "territoryStarted"
        static let loadStart = "loadStart"
        static let reloadData = "reloadData"
        static let allLoadingCompleted = "allLoadingCompleted"
        static let orientationChange = "orientationChange"
        static let displayToolbar = "displayToolbar"
    }
    
    // NSNotifications
    struct sideMenu {
        static let toggleMenuButton = "toggleMenuButton"
        static let openMenu = "openMenu"
        static let closeMenu = "closeMenu"
        static let territories = "territories"
        static let loadOptions = "loadOptions"
        static let translateOptions = "translateOptions"
        static let share = "share"
        static let askReview = "askReview"
        static let help = "help"
        static let about = "about"
    }
}
