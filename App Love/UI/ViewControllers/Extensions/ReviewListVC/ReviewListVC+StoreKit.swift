//
//  ReviewListVC+StoreKit.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit
import StoreKit

// app store
extension ReviewListVC: SKStoreProductViewControllerDelegate {
    
    func showStore(id:Int) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier :
            NSNumber(integer: id)]
        storeViewController.loadProductWithParameters(parameters,
                                                      completionBlock: {result, error in
                                                        if result {
                                                            self.presentViewController(storeViewController,
                                                                animated: true, completion: nil)
                                                            // remove loading animation
                                                        }
        })
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}