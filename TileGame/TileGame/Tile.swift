//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit
import UIKit

class Tile: SKSpriteNode {

    var place: (row: Int, column: Int)
    var type: TileType
    var childTile: Tile? {
        didSet {
            if let tile = childTile {
                childTile?.position = CGPointZero
                childTile?.userInteractionEnabled = false
                childTile?.runAction(SKAction.scaleTo(0.5, duration: 0))
                self.addChild(tile)
            }
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tileRow: Int, tileColumn: Int, tileType: TileType, tileDelegate: GameScene) {
        place.row = tileRow
        place.column = tileColumn
        type = tileType
        
        if tileType == TileType.Star {
            super.init(texture: Constants.starTexture, color: SKColor.yellowColor(), size: Constants.tileSize)
        } else {
            super.init(texture: Constants.tileTexture, color: tileType.tileColor, size: Constants.tileSize)
        }
        
        position = Constants.boardPositions[place.row][place.column]
        
        colorBlendFactor = 1.0
        userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.delegate?.tileDragBegan(self, touch: touches.first as! UITouch)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.delegate?.tileDragMoved(self, touch: touches.first as! UITouch)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
//        self.delegate?.tileDragCancelled(self, touch: touches.first as! UITouch)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.delegate?.tileDragEnded(self, touch: touches.first as! UITouch)
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
    
    static func random() -> TileType {
        return TileType(rawValue: Int(arc4random_uniform(6) + 1))!
    }
}

enum Direction: Int {
    case None = -1, Right, Up, Left, Down
}

enum Orientation: Int {
    case None = -1, Horizontal, Vertical
}