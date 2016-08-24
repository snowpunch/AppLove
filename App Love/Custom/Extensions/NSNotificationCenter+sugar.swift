//
//  NSNotificationCenter+sugar.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-07.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Syntatic Suger. More condenced forms of adding observers and posting.

import Foundation

extension NSNotificationCenter {
    
    class func post (aName: String, object: AnyObject?=nil) {
        NSNotificationCenter.defaultCenter().postNotificationName(aName, object: object)
    }

    class func addObserver (observer: AnyObject, sel: Selector, name aName: String?, object anObject: AnyObject?=nil) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: sel, name: aName, object: anObject)
    }
}