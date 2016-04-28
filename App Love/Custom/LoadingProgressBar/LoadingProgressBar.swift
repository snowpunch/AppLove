//
//  LoadingProgressBar.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-19.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Progress bar of progressBars.
//  Mini bars each represent a territory.
//

import UIKit
import Foundation

class LoadingProgressBar: UIView {
    
    var loadStates = [String:LoadState]() // Redundant for visuals. ReviewLoadManager has truth.
    var loaderPieces = [String:TerritoryBar]()
    var xPosition = 15
    var barYPosition:Int = 42
    var loaderBarHeight = 30
    let maxTerritoryBarWidth:CGFloat = 21.0
    
    func createBar() {
        self.frame = CGRect(x: 0,y: barYPosition,width: 0,height:loaderBarHeight)
        self.backgroundColor = .clearColor()
        loadStart()
    }
    
    func loadStart() {
        cleanup()
        registerNotifications()
        reRenderForNewWidth()
    }
    
    func reRenderForNewWidth() {
        cleanup()
        createPieces()
        registerNotifications()
        setFromManager()
    }
    
    func registerNotifications() {
        unregisterNotifications()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: .loadStart, name: Const.loadStart, object: nil)
        nc.addObserver(self, selector: .dataError, name: Const.dataError, object:nil)
        nc.addObserver(self, selector: .territoryStarted, name: Const.territoryStart, object: nil)
        nc.addObserver(self, selector: .territoryCompleted, name: Const.territoryDone, object: nil)
        nc.addObserver(self, selector: .updateAmount, name: Const.updateAmount, object: nil)
        nc.addObserver(self, selector: .reRenderForNewWidth, name: Const.orientationChange, object: nil)
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dataError(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let territory = userInfo["territory"] as? String else { return }
        guard loaderPieces[territory] != nil else { return }
        guard let territoryBar = loaderPieces[territory] else { return }
        territoryBar.showError()
    }

    func territoryStarted(notification: NSNotification) {
        guard let territory = notification.userInfo?["territory"] as? String else { print("bb"); return }
        guard loaderPieces[territory] != nil else { return }
        let box = loaderPieces[territory]! as TerritoryBar // crash when increase territories
        box.activeLoadingStart()
    }
    
    func territoryCompleted(notification: NSNotification) {
        guard let territory = notification.userInfo?["territory"] as? String else { print("bb"); return }
        guard loaderPieces[territory] != nil else { return }
        let box = loaderPieces[territory]! as TerritoryBar // crash when increase territories
        if let loadState = self.loadStates[territory] {
            box.finishedLoading(loadState)
        }
    }

    func updateAmount(notification: NSNotification) {
        guard let dic = notification.userInfo else { return }
        guard let territory = dic["territory"] as? String else { return }
        guard loaderPieces[territory] != nil else { return }
        guard let loadState = dic["loadState"] as? LoadState else { return }
        guard let box = loaderPieces[territory] else { return }
        box.updateProgress(loadState)
    }
    
    // if headerCell is recreated we init from ReviewLoadManager (truth).
    func setFromManager() {
        self.loadStates.removeAll()
        loadStates = ReviewLoadManager.sharedInst.loadStates
        
        for (key,box) in loaderPieces {
            if let loadState = self.loadStates[key] {
                box.restoreState(loadState)
            }
        }
    }

    func cleanup() {
        for item in loaderPieces.values {
            item.removeFromSuperview()
        }
        self.loadStates.removeAll()
        self.loaderPieces.removeAll()
        xPosition = 15
    }
    
    func createPieces() {
        let territoryCodes = TerritoryMgr.sharedInst.getSelectedCountryCodes()
        let pieceWidth = getPieceWidth()
        
        if canDisplayTextWithPieces() {
            let spacing = 2
            for code in territoryCodes {
                let piece = TerritoryBarWithText(territoryCode: code, width: pieceWidth, height: 30)
                addPieceToBar(piece, code:code, spacing:spacing)
            }
        }
        else {
            let spacing = (pieceWidth == 1 ? 0 : 1)
            for code in territoryCodes {
                let piece = TerritoryBar(territoryCode: code, width: pieceWidth, height: 44)
                addPieceToBar(piece, code:code, spacing:spacing)
            }
        }
    }
    
    func addPieceToBar(piece:TerritoryBar,code:String, spacing:Int) {
        self.loadStates[code] = LoadState(territory: code)
        self.addSubview(piece)
        piece.center = CGPoint(x: xPosition, y: 1)
        xPosition += piece.width + spacing
        loaderPieces[code] = piece
    }
    
    func getPieceWidth() -> CGFloat {
        let numberBars = CGFloat(TerritoryMgr.sharedInst.getSelectedCountryCodes().count)
        let borderSpace:CGFloat = 30.0
        let spaceAvail = UIScreen.mainScreen().bounds.size.width - (borderSpace + numberBars)
        var pieceWidth = (spaceAvail / numberBars)
        if pieceWidth > maxTerritoryBarWidth {
            pieceWidth = maxTerritoryBarWidth
        }
        if pieceWidth < 1 {
            pieceWidth = 1.0
        }
        return pieceWidth
    }
    
    func canDisplayTextWithPieces() -> Bool {
        if getPieceWidth() == maxTerritoryBarWidth {
            return true
        }
        return false
    }
    
    deinit {
        unregisterNotifications()
        cleanup()
    }
}

private extension Selector {
    static let loadStart = #selector(LoadingProgressBar.loadStart)
    static let dataError = #selector(LoadingProgressBar.dataError(_:))
    static let territoryStarted = #selector(LoadingProgressBar.territoryStarted(_:))
    static let territoryCompleted = #selector(LoadingProgressBar.territoryCompleted(_:))
    static let updateAmount = #selector(LoadingProgressBar.updateAmount(_:))
    static let reRenderForNewWidth = #selector(LoadingProgressBar.reRenderForNewWidth)
}