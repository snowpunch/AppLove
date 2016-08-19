//
//  ReviewListVC+CVDataSource.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//

import UIKit

extension ReviewListVC: UICollectionViewDataSource {
    
    func showEmptyView() {
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        appName.text = "Select an App"
        aveRating.text = "on the left"
    }
    
    func setupCollection() {
        
        territoryCollection.delegate = self
        territoryCollection.dataSource = self
        territoryCollection.bounces = true
        territoryCollection.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        territoryCollection.registerClass(TerritoryLoadCell.self, forCellWithReuseIdentifier: "territoryLoadCell")
        territoryCollection.registerNib(UINib(nibName: "TerritoryLoadCell", bundle: nil), forCellWithReuseIdentifier: "territoryLoadCell")
        
        // App Info
        if let appModel = AppList.sharedInst.getSelectedModel(),
            let urlStr = appModel.icon100,
            let url =  NSURL(string:urlStr) {
            appIcon.sd_setImageWithURL(url, placeholderImage: UIImage(named:"defaulticon"))
            appName.text = appModel.appName
            let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
            aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
            territoryCollection.reloadData()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReviewLoadManager.sharedInst.loadStates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("territoryLoadCell", forIndexPath: indexPath) as! TerritoryLoadCell
        
        let loadState = ReviewLoadManager.sharedInst.loadStateArray[indexPath.row]
        
        cell.setup(loadState)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
}

extension ReviewListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let sideSize = CGSize(width: 26,height: 43)
        return sideSize;
    }
}

// Territory Loading CollectionView
extension ReviewListVC {
    

    
    func scrollFlagsToEnd() {
        let finalPos =  ReviewLoadManager.sharedInst.loadStateArray.count - 1
        if finalPos > 0 {
            let path = NSIndexPath(forItem: finalPos, inSection: 0)
            if path != NSNotFound {
                territoryCollection.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            }
        }
    }
    
    func scrollFlagsToBeginning() {
        let finalPos =  0
        let path = NSIndexPath(forItem: finalPos, inSection: 0)
        territoryCollection.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func startLoading() {
        scrollFlagsToBeginning()
    }
    
    // scrollToEndWhenFinishedLoading
    func finishedLoading() {
        scrollFlagsToEnd()
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
    }
    
    func updateLoadingCount(notification: NSNotification) {
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Loading Reviews : "+String(totalReviewsLoaded)
    }
}