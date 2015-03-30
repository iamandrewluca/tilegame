//
//  LobbyVC.swift
//  TileGame
//
//  Created by Andrei Luca on 3/29/15.
//  Copyright (c) 2015 TileGame. All rights reserved.
//

import UIKit

class LobbyVC: UICollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = (collectionView.dequeueReusableCellWithReuseIdentifier("LobbyCell", forIndexPath: indexPath) as LobbyCollectionViewCell)
        cell.numberLabel.text = String(indexPath.row)
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
