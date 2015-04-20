//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {
    
    var row: Int
    var column: Int
    var type: TileType
    var visited: Bool = false
    var childTile: Tile? {
        didSet {
            if let tile = childTile {
                childTile?.position = CGPointZero
                childTile?.userInteractionEnabled = false
                childTile?.runAction(SKAction.scaleBy(0.5, duration: 0))
                self.addChild(tile)
            }
        }
    }
    
    // tipa "delegate"
    var delegate: GameScene?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tileRow: Int, tileColumn: Int, tileType: TileType, tileDelegate: GameScene) {
        
        row = tileRow
        column = tileColumn
        type = tileType
        delegate = tileDelegate
        
        if tileType == TileType.Star {
            super.init(texture: SKTexture(imageNamed: "Star"), color: SKColor.whiteColor(), size: Constants.tileSize)
        } else {
            super.init(texture: Constants.tileTexture, color: tileType.tileColor, size: Constants.tileSize)
        }
        
        position = Constants.boardPositions[row][column]
        
        colorBlendFactor = 1.0
        userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.delegate?.tileDragBegan(self, touch: touches.first as! UITouch)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.delegate?.tileDragMoved(self, touch: touches.first as! UITouch)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.delegate?.tileDragCancelled(self, touch: touches.first as! UITouch)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.delegate?.tileDragEnded(self, touch: touches.first as! UITouch)
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
    case Right = 0, Up, Left, Down, None
}

enum Orientation: Int {
    case Horizontal = 0, Vertical, None
}