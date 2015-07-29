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

    // MARK: Static Members

    // 6*x+5*(x/8)+2*(x/4)=deviceWidth
    // 6 tiles + 5 spaces + 2 margins = deviceWidth
    static let tileLength = Constants.screenSize.width * 8 / 57
    static let tileSize = CGSize(width: tileLength, height: tileLength)

    // MARK: Members

    var type: TileType

    var place = (row: 0, column: 0) {
        didSet {
            if let child = childTile {
                child.place = place
            }
        }
    }

    var childTile: Tile? {
        didSet {
            if let tile = childTile {
                childTile?.position = CGPointZero
                childTile?.zPosition = 1
                childTile?.userInteractionEnabled = false
                childTile?.setScale(0.5)
                self.addChild(tile)
            }
        }
    }

    // MARK: Methods

    // MARK: SKSpriteNode

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tileRow: Int, tileColumn: Int, tileType: TileType) {
        place.row = tileRow
        place.column = tileColumn
        type = tileType
        
        if type != TileType.Unknown {

            if tileType == TileType.Star {
                super.init(texture: GameScene.starTexture, color: Constants.starColor, size: Tile.tileSize)
            } else {
                super.init(texture: GameScene.tileTexture, color: tileType.tileColor, size: Tile.tileSize)
            }

            colorBlendFactor = 1.0
            userInteractionEnabled = true
        } else {
            super.init(texture: nil, color: SKColor.clearColor(), size: Tile.tileSize)
        }
        
        position = Board.boardPositions[place.row][place.column]

    }

    override func removeFromParent() {
        super.removeFromParent()

        if type != TileType.Star {
            userInteractionEnabled = true
        }
    }

    // MARK: Touches
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        (self.scene as! GameScene).tileDragBegan(self, touch: touches.first as! UITouch)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        (self.scene as! GameScene).tileDragMoved(self, touch: touches.first as! UITouch)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        (self.scene as! GameScene).tileDragCancelled(self, touch: touches.first as! UITouch)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        (self.scene as! GameScene).tileDragEnded(self, touch: touches.first as! UITouch)
    }
}

enum TileType: Int {
    case Unknown = -1, Empty, Color1, Color2, Color3, Color4, Color5, Star
    
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
            return SKColor.clearColor()
        }
    }
}

enum Direction: Int {
    case None = -1, Right, Up, Left, Down
}

enum Orientation: Int {
    case None = -1, Horizontal, Vertical
}