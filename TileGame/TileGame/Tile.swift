//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var row = 0
    var column = 0
    var type = 0
    var childTile: Tile?
    
    init(column: Int, row: Int, tileType: TileType) {
        super.init()
        
        userInteractionEnabled = true
    }
}

enum TileType {
    case Unknown, Blue, Green, Red, Yellow, Purple, Star, Empty
}
