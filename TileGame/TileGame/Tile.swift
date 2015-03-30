//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit
import SpriteKit

class Tile: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var row = 0
    var column = 0
    var type = 0
    
    init(column: Int, row: Int) {
        super.init()
    }
}
