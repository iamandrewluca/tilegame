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
    static let tileLength: CGFloat = Constants.screenSize.width * 8 / 57
    static let tileSize: CGSize = CGSize(width: tileLength, height: tileLength)
    static let tileCornerRadius: CGFloat = tileLength / 4
    static let tileSpacing: CGFloat = tileLength / 8

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
                tile.position = CGPointZero
                tile.userInteractionEnabled = false
                tile.setScale(0.5)
                self.removeAllChildren()
                self.addChild(tile)
            }
        }
    }

    // MARK: Methods

    // MARK: SKSpriteNode

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(row: Int, column: Int, tileType: TileType) {
        place.row = row
        place.column = column
        type = tileType
        
        if type != TileType.Hole {

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
        
        position = GameScene.boardPositions[place.row][place.column]

    }

    override func removeFromParent() {
        super.removeFromParent()

        if type != TileType.Star {
            userInteractionEnabled = true
        }
    }

    // MARK: Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = self.scene as? GameScene {
            scene.tileDragBegan(self, at: touches.first!.locationInNode(scene))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = self.scene as? GameScene {
            scene.tileDragMoved(self, at: touches.first!.locationInNode(scene))
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = self.scene as? GameScene {
            scene.tileDragEnded(self, at: touches.first!.locationInNode(scene))
        }
    }
}