//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {
    
    var row = 0
    var column = 0
    var tileType = 0
    var childTile: Tile?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: TileType, delegate: GameScene) {
        let gc = GameConstants.sharedInstance!
        super.init(texture: gc.tileTexture, color: type.tileColor, size: gc.tileSize)
    }
}

enum TileType: Int {
    case Unknown = 0, Color1, Color2, Color3, Color4, Color5, Star, Empty
    
    var tileColor: SKColor {
        switch self {
        case .Color1:
            return Constants.Color1
        case .Color2:
            return Constants.Color2
        case .Color3:
            return Constants.Color3
        case .Color4:
            return Constants.Color4
        case .Color5:
            return Constants.Color5
        default:
            return SKColor.redColor()
        }
    }
}
