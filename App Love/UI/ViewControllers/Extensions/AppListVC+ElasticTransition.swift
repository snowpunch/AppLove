//
//  AppListVC+elastic.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import Foundation
import ElasticTransition

// elastic extensions
extension AppListViewVC {

    func initElasticTransitions(){
        transition.stiffness = 0.7
        transition.damping = 0.40
        transition.stiffness = 1
        transition.damping = 0.75
        transition.transformType = .TranslateMid
    }

    func displayElasticOptions(viewControlerId:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier(viewControlerId)
            aboutVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            transition.edge = .Bottom
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            transition.showShadow = true
            transition.transformType = .Rotate
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .Custom
            presentViewController(aboutVC, animated: true, completion: nil)
        }
    }

    func elasticPresentViewController(storyBoardID:String) {
        if let storyboard = self.storyboard {
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier(storyBoardID)
            transition.edge = .Right
            transition.startingPoint = CGPoint(x:30,y:70)
            transition.stiffness = 1
            transition.damping = 0.75
            aboutVC.transitioningDelegate = transition
            aboutVC.modalPresentationStyle = .Custom
            presentViewController(aboutVC, animated: true, completion: nil)
        }
    }

    func openElasticMenu() {
        transition.edge = .Left
        transition.startingPoint = CGPoint(x:30,y:70)
        transition.showShadow = false
        transition.transformType = .TranslateMid
        performSegueWithIdentifier("menu", sender: self)
    }
}