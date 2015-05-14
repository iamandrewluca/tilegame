//
//  LobbyCollectionViewLayout.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import UIKit

class LobbyCollectionViewLayout : UICollectionViewLayout {
    
    var itemInsets: UIEdgeInsets
    var itemSize: CGSize
    var numberOfColumns: Int
    
    override init() {
        
        itemInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        itemSize = CGSizeMake(145, 145)
        numberOfColumns = 2
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareLayout() {
        //
    }
}