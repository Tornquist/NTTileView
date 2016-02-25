//
//  NTTileView.swift
//  NTTileView
//
//  Created by Nathan Tornquist on 2/22/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//

import UIKit

public class NTTileView: UIView {
    
    /**
     NTTileView Data Source.
     
     This object will provide the data for the tile view, and
     must conform to the NTTileViewDataSource protocol.
     
     refreshTiles() will be called on the tile view after setting
     a new data source.
     */
    var _dataSource: NTTileViewDataSource?
    public var dataSource: NTTileViewDataSource? {
        get {
            return _dataSource
        }
        set {
            _dataSource = newValue
            refreshTiles()
        }
    }
    
    /**
     NTTileView Layout.
     
     This object will provide the layouting for the tile view, and
     must conform to NTTileViewLayoutProtocol.
     
     All of the view sizes and arrangement will be set by this object.
     
     refreshTiles() will be called on the tile view after setting
     a new data source.
     */
    var _layout: NTTileViewLayoutProtocol = NTTileViewRowLayout()
    public var layout: NTTileViewLayoutProtocol {
        get {
            return _layout
        }
        set {
            _layout = newValue
            refreshTiles()
        }
    }
    
    /**
     This holds the NTTiles, the actual objects that will be shown
     */
    var tiles: [NTTile] = []
    
    /**
     Every tile is nested within a view.  These views are what is
     actually resized and arranged in the interface.  This is the
     collection of those views.
     */
    var views: [UIView] = []
    
    public func refreshTiles() {
        guard dataSource != nil else {
            NSLog("NTTileView - nil data source, cannot refresh tiles")
            return
        }
        
        let numTiles = dataSource!.numberOfTiles(self)
        tiles.removeAll()
        views.removeAll()
        for i in 0..<numTiles {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            addTile(dataSource!.tileAt(indexPath: indexPath))
        }
        arrangeTiles()
    }
    
    public func arrangeTiles() {
        layout.resetTileLayout(self)
    }
    
    func addTile(tile: NTTile) {
        let newView = UIView()
        newView.autoresizesSubviews = false
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.clipsToBounds = true
        self.addSubview(newView)
        newView.addSubview(tile)
        tile.parentTileView = self
        
        views.append(newView)
        tiles.append(tile)
    }
    
    /**
     Given an internal index of a specific tile, this method is used
     to focus on that tile.  The actual action performed will depend
     on the layouting engine used
     */
    public func focus(onTileWithIndex tileIndex: Int) {
        NSLog("Expand Tile \(tileIndex)")
        layout.focus(self, onTileWithIndex: tileIndex)
    }
    
    /**
     This method will return the index of a current tile.  Depending
     on the layout engine used, the tile index may not correspond to the
     actual on-screen layout.  This is an internal index used by NTTileView
     to manage the tiles and views they are displayed within.
     
     This index can be used to perform operations (such as expand)
     on a specific tile.
     */
    public func getTileIndex(withTile tile: NTTile) -> Int? {
        for (i, t) in tiles.enumerate() {
            if t === tile {
                return i
            }
        }
        return nil
    }
}
